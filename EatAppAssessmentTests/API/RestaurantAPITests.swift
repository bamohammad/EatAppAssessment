//
//  RestaurantAPITests.swift
//  EatAppAssessment
//
//  Created by Ali Bamohammad on 18/06/2025.
//

@testable import EatAppAssessment
import XCTest

@MainActor
final class RestaurantAPITests: XCTestCase {
    // MARK: – Stored mocks

    private var mockClient: MockAPIClient!

    // MARK: – Test bootstrap

    override func setUp() {
        super.setUp()

        DIContainer.shared.reset()

        mockClient = MockAPIClient()
        DIContainer.shared.register(APIClient.self) { [unowned self] in mockClient }

        DIContainer.shared.register(RestaurantAPI.self) {
            DefaultRestaurantAPI(client: DIContainer.shared.resolve())
        }
    }

    override func tearDown() {
        mockClient = nil
        super.tearDown()
    }

    /// Convenience
    private func makeSUT() -> RestaurantAPI {
        DIContainer.shared.resolve(RestaurantAPI.self)
    }

    // MARK: – Tests

    func test_whenFetchSucceeds_thenParsesDTOsCorrectly() async throws {
        // Arrange
        mockClient.result = .success(validJSON)
        let sut = makeSUT()

        // Act
        let result = try await sut.fetchRestaurants(regionId: "some region id", page: 1, limit: 2)

        // Assert (subset)
        XCTAssertEqual(result.data?.count, 2)
        let first = result.data?.first
        XCTAssertEqual(first?.id, "14bf9273-64f3-4b39-875b-a616fc83f453")
        XCTAssertEqual(first?.attributes?.name, "Miss Tess")
        XCTAssertEqual(first?.attributes?.priceLevel, 2)
        XCTAssertEqual(result.meta?.limit, 2)
        XCTAssertEqual(result.meta?.totalPages, 7)
    }

    func test_whenResponseIsMalformedJSON_thenThrowsDecodingError() async {
        // Arrange
        mockClient.result = .success(Data("invalid json".utf8))
        let sut = makeSUT()

        // Act - Assert
        await XCTAssertThrowsErrorAsync(
            try await sut.fetchRestaurants(regionId: "some", page: 1, limit: 2)
        ) { XCTAssertTrue($0 is DecodingError) }
    }

    func test_whenClientFails_thenThrowsError() async {
        // Arrange
        mockClient.result = .failure(NSError(domain: "Net", code: -1009))
        let sut = makeSUT()

        // Act - Assert
        await XCTAssertThrowsErrorAsync(
            try await sut.fetchRestaurants(regionId: "some", page: 1, limit: 2)
        ) { err in
            let ns = err as NSError
            XCTAssertEqual(ns.domain, "Net")
            XCTAssertEqual(ns.code, -1009)
        }
    }

    func test_whenResponseHasIncompleteData_thenParsesAvailableFields() async throws {
        // Arrange
        mockClient.result = .success(minimalJSON)
        let sut = makeSUT()

        // Act
        let result = try await sut.fetchRestaurants(regionId: "some", page: 1, limit: 1)

        // Assert
        XCTAssertEqual(result.data?.first?.attributes?.name, "Minimal Restaurant")
        XCTAssertNil(result.data?.first?.attributes?.menuUrl)
    }

    func test_apiRequestParameters_areSetCorrectly() async throws {
        let spy = SpyAPIClient()
        DIContainer.shared.register(APIClient.self) { spy }
        let sut = DefaultRestaurantAPI(client: DIContainer.shared.resolve())

        // Act
        _ = try? await sut.fetchRestaurants(regionId: "some region id", page: 3, limit: 15)

        // Assert
        XCTAssertEqual(spy.capturedRequest?.path, "/consumer/v2/restaurants")
        XCTAssertEqual(spy.capturedRequest?.method, .GET)
        XCTAssertEqual(spy.capturedRequest?.headers["Content-Type"], "application/json")

        let qi = spy.capturedRequest?.queryItems ?? []
        XCTAssertTrue(qi.contains(URLQueryItem(name: "region_id", value: "some region id")))
        XCTAssertTrue(qi.contains(URLQueryItem(name: "limit", value: "15")))
        XCTAssertTrue(qi.contains(URLQueryItem(name: "page", value: "3")))
    }

    // MARK: – JSON fixtures

    private var validJSON: Data {
        """
        {
            "data": [
                {
                    "id": "14bf9273-64f3-4b39-875b-a616fc83f453",
                    "type": "restaurant",
                    "attributes": {
                        "name": "Miss Tess",
                        "price_level": 2,
                        "phone": "+97144262626",
                        "menu_url": "https://example.com/menu.pdf",
                        "require_booking_preference_enabled": false,
                        "difficult": false,
                        "cuisine": "Asian",
                        "image_url": "https://ucarecdn.com/a0f30bef-d067-4278-a256-f14448040504/",
                        "latitude": 25.192265,
                        "longitude": 55.267255,
                        "address_line_1": "Business Bay",
                        "ratings_average": "4.5",
                        "ratings_count": 195,
                        "labels": [
                            "Casual",
                            "Good for Groups",
                            "Good for Families"
                        ]
                    },
                    "relationships": {
                        "region": {
                            "data": {
                                "id": "3906535a-d96c-47cf-99b0-009fc9e038e0",
                                "type": "region"
                            }
                        }
                    }
                },
                {
                    "id": "ac68670a-7cba-45f8-8eb1-801f63cc08c2",
                    "type": "restaurant",
                    "attributes": {
                        "name": "Nobu",
                        "price_level": 3,
                        "phone": "+97144262626",
                        "menu_url": null,
                        "require_booking_preference_enabled": false,
                        "difficult": false,
                        "cuisine": "Japanese",
                        "image_url": "https://ucarecdn.com/a117956c-356d-4cd1-8aa2-61882a4b5979/",
                        "latitude": 25.132155,
                        "longitude": 55.117581,
                        "address_line_1": "Ground Level, The Avenues, Atlantis",
                        "ratings_average": "4.0",
                        "ratings_count": 2126,
                        "labels": [
                            "Dressy",
                            "Good for Brunch",
                            "Good for Dinner"
                        ]
                    },
                    "relationships": {
                        "region": {
                            "data": {
                                "id": "3906535a-d96c-47cf-99b0-009fc9e038e0",
                                "type": "region"
                            }
                        }
                    }
                }
            ],
            "meta": {
                "limit": 2,
                "total_pages": 7,
                "total_count": 14,
                "current_page": 1
            },
            "links": {
                "first": "https://api.eat-sandbox.co/consumer/v2/restaurants?limit=2&page=1",
                "next": "https://api.eat-sandbox.co/consumer/v2/restaurants?limit=2&page=2",
                "prev": null,
                "last": "https://api.eat-sandbox.co/consumer/v2/restaurants?limit=2&page=7"
            }
        }
        """.data(using: .utf8)!
    }

    private var minimalJSON: Data {
        """
        {
            "data": [
                {
                    "id": "minimal-restaurant",
                    "type": "restaurant",
                    "attributes": {
                        "name": "Minimal Restaurant",
                        "price_level": 1,
                        "phone": null,
                        "menu_url": null,
                        "require_booking_preference_enabled": true,
                        "difficult": true,
                        "cuisine": "Fast Food",
                        "image_url": "https://example.com/image.jpg",
                        "latitude": 25.0,
                        "longitude": 55.0,
                        "address_line_1": "Test Address",
                        "ratings_average": "3.0",
                        "ratings_count": 50,
                        "labels": []
                    },
                    "relationships": {
                        "region": {
                            "data": {
                                "id": "test-region-id",
                                "type": "region"
                            }
                        }
                    }
                }
            ],
            "meta": {
                "limit": 1,
                "total_pages": 1,
                "total_count": 1,
                "current_page": 1
            },
            "links": {
                "first": "https://api.example.com/page=1",
                "next": null,
                "prev": null,
                "last": "https://api.example.com/page=1"
            }
        }
        """.data(using: .utf8)!
    }
}
