//
//  RestaurantAPITests.swift
//  EatAppAssessment
//
//  Created by Ali Bamohammad on 18/06/2025.
//


import XCTest
@testable import EatAppAssessment


final class RestaurantAPITests: XCTestCase {
    
    private func makeSUT(client: APIClient) -> RestaurantAPI {
        DefaultRestaurantAPI(client: client)
    }

    func test_whenFetchSucceeds_thenParsesDTOsCorrectly() async throws {
        // Arrange
        let json = """
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

        let client = MockAPIClient()
        client.result = .success(json)
        let sut = makeSUT(client: client)

        // Act
        let result = try await sut.fetchRestaurants(regionId: "some region id", page: 1, limit: 2)

        // Assert
        XCTAssertEqual((result.data?.count ?? 0), 2)
        
        // Test first restaurant
        let firstRestaurant = result.data?.first
        XCTAssertEqual(firstRestaurant?.id, "14bf9273-64f3-4b39-875b-a616fc83f453")
        XCTAssertEqual(firstRestaurant?.type, "restaurant")
        XCTAssertEqual(firstRestaurant?.attributes?.name, "Miss Tess")
        XCTAssertEqual(firstRestaurant?.attributes?.priceLevel, 2)
        XCTAssertEqual(firstRestaurant?.attributes?.cuisine, "Asian")
        XCTAssertEqual(firstRestaurant?.attributes?.ratingsAverage, "4.5")
        XCTAssertEqual(firstRestaurant?.attributes?.ratingsCount, 195)
        XCTAssertEqual(firstRestaurant?.attributes?.latitude, 25.192265)
        XCTAssertEqual(firstRestaurant?.attributes?.longitude, 55.267255)
        XCTAssertEqual(firstRestaurant?.attributes?.addressLine1, "Business Bay")
        XCTAssertEqual(firstRestaurant?.attributes?.labels?.count, 3)
        XCTAssertNotNil(firstRestaurant?.attributes?.labels?.contains("Casual"))
        XCTAssertEqual(firstRestaurant?.relationships?.region?.data?.id, "3906535a-d96c-47cf-99b0-009fc9e038e0")
        
        // Test second restaurant
        let secondRestaurant = result.data?[1]
        XCTAssertEqual(secondRestaurant?.id, "ac68670a-7cba-45f8-8eb1-801f63cc08c2")
        XCTAssertEqual(secondRestaurant?.attributes?.name, "Nobu")
        XCTAssertEqual(secondRestaurant?.attributes?.priceLevel, 3)
        XCTAssertEqual(secondRestaurant?.attributes?.cuisine, "Japanese")
        XCTAssertEqual(secondRestaurant?.attributes?.ratingsAverage, "4.0")
        XCTAssertEqual(secondRestaurant?.attributes?.ratingsCount, 2126)
        XCTAssertNil(secondRestaurant?.attributes?.menuUrl)
        
        // Test pagination metadata
        XCTAssertEqual(result.meta?.limit, 2)
        XCTAssertEqual(result.meta?.totalPages, 7)
        XCTAssertEqual(result.meta?.totalCount, 14)
        XCTAssertEqual(result.meta?.currentPage, 1)
        
    }

    func test_whenResponseIsMalformedJSON_thenThrowsDecodingError() async {
        // Arrange
        let client = MockAPIClient()
        client.result = .success(Data("invalid json".utf8))
        let sut = makeSUT(client: client)

        // Act & Assert
        await XCTAssertThrowsErrorAsync(try await sut.fetchRestaurants(regionId: "some region id", page: 1, limit: 2)) { error in
            XCTAssertTrue(error is DecodingError)
        }
    }

    func test_whenClientFails_thenThrowsError() async {
        // Arrange
        let client = MockAPIClient()
        client.result = .failure(NSError(domain: "Net", code: -1009))
        let sut = makeSUT(client: client)

        // Act & Assert
        await XCTAssertThrowsErrorAsync(try await sut.fetchRestaurants(regionId: "some region id", page: 1, limit: 2)) { error in
            let nsError = error as NSError
            XCTAssertEqual(nsError.domain, "Net")
            XCTAssertEqual(nsError.code, -1009)
        }
    }
    
    func test_whenResponseHasIncompleteData_thenParsesAvailableFields() async throws {
        // Arrange - Test with minimal required fields
        let json = """
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

        let client = MockAPIClient()
        client.result = .success(json)
        let sut = makeSUT(client: client)

        // Act
        let result = try await sut.fetchRestaurants(regionId: "some region id", page: 1, limit: 1)

        // Assert
        XCTAssertEqual(result.data?.count, 1)
        let restaurant = result.data?.first
        XCTAssertEqual(restaurant?.attributes?.name, "Minimal Restaurant")
        XCTAssertEqual(restaurant?.attributes?.priceLevel, 1)
        XCTAssertNil(restaurant?.attributes?.phone)
        XCTAssertNil(restaurant?.attributes?.menuUrl)
        XCTAssertTrue(restaurant?.attributes?.requireBookingPreferenceEnabled ?? false)
        XCTAssertTrue(restaurant?.attributes?.difficult ?? false)
        XCTAssertNotNil(restaurant?.attributes?.labels)
    }
    
    func test_apiRequestParameters_areSetCorrectly() async throws {
        // Arrange
        let mockClient = SpyAPIClient()
        let sut = makeSUT(client: mockClient)
        
        // Act
        _ = try? await sut.fetchRestaurants(regionId: "some region id", page: 3, limit: 15)
        
        // Assert
        XCTAssertEqual(mockClient.capturedRequest?.path, "/consumer/v2/restaurants")
        XCTAssertEqual(mockClient.capturedRequest?.method, .GET)
        XCTAssertEqual(mockClient.capturedRequest?.headers["Content-Type"], "application/json")
        
        let queryItems = mockClient.capturedRequest?.queryItems ?? []
        XCTAssertTrue(queryItems.contains(URLQueryItem(name: "region_id", value: "some region id")))
        XCTAssertTrue(queryItems.contains(URLQueryItem(name: "limit", value: "15")))
        XCTAssertTrue(queryItems.contains(URLQueryItem(name: "page", value: "3")))
    }
}


