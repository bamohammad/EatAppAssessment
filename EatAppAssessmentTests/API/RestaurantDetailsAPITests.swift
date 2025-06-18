//
//  RestaurantDetailsAPITests.swift
//  EatAppAssessmentTests
//
//  Created by Ali Bamohammad on 19/06/2025.
//

@testable import EatAppAssessment
import XCTest

final class RestaurantDetailsAPITests: XCTestCase {
    
    // MARK: - SUT Factory
    private func makeSUT(client: APIClient) -> RestaurantDetailsAPI {
        DefaultRestaurantDetailsAPI(client: client)
    }

    // MARK: - Tests

    func test_whenFetchSucceeds_thenParsesDTOCorrectly() async throws {
        // Arrange
        let json = """
        {
          "data": {
            "id": "098301ea-6f1e-45c2-8958-f34df4cdeea8",
            "type": "restaurant",
            "attributes": {
              "name": "Ronda Locatelli",
              "price_level": 2,
              "phone": "+97144262626",
              "menu_url": "https://example.com/menu.pdf",
              "require_booking_preference_enabled": false,
              "difficult": false,
              "cuisine": "Italian",
              "image_url": "https://example.com/img.jpg",
              "latitude": 25.13,
              "longitude": 55.11,
              "address_line_1": "Dubai",
              "ratings_average": "4.0",
              "ratings_count": 1445,
              "labels": ["Smart Casual", "Good for Dinner"]
            }
          }
        }
        """.data(using: .utf8)!

        let client = MockAPIClient()
        client.result = .success(json)
        let sut = makeSUT(client: client)

        // Act
        let dto = try await sut.fetchRestaurant(id: "098301ea-6f1e-45c2-8958-f34df4cdeea8")

        // Assert
        XCTAssertEqual(dto.data?.id, "098301ea-6f1e-45c2-8958-f34df4cdeea8")
        XCTAssertEqual(dto.data?.attributes?.name, "Ronda Locatelli")
        XCTAssertEqual(dto.data?.attributes?.cuisine, "Italian")
        XCTAssertEqual(dto.data?.attributes?.priceLevel, 2)
        XCTAssertEqual(dto.data?.attributes?.ratingsAverage, "4.0")
        XCTAssertEqual(dto.data?.attributes?.labels?.count, 2)
    }

    func test_whenResponseIsMalformedJSON_thenThrowsDecodingError() async {
        // Arrange
        let client = MockAPIClient()
        client.result = .success(Data("not json".utf8))
        let sut = makeSUT(client: client)

        // Act & Assert
        await XCTAssertThrowsErrorAsync(
            try await sut.fetchRestaurant(id: "bad")
        ) { error in
            XCTAssertTrue(error is DecodingError)
        }
    }

    func test_whenClientFails_thenThrowsError() async {
        // Arrange
        let client = MockAPIClient()
        client.result = .failure(NSError(domain: "Net", code: -1001))
        let sut = makeSUT(client: client)

        // Act & Assert
        await XCTAssertThrowsErrorAsync(
            try await sut.fetchRestaurant(id: "foo")
        ) { error in
            let ns = error as NSError
            XCTAssertEqual(ns.domain, "Net")
            XCTAssertEqual(ns.code, -1001)
        }
    }

    func test_whenResponseHasIncompleteData_thenParsesOptionalsCorrectly() async throws {
        // Arrange
        let json = """
        {
          "data": {
            "id": "min",
            "type": "restaurant",
            "attributes": {
              "name": "Mini",
              "price_level": 2,
              "phone": "+97144262626",
              "require_booking_preference_enabled": false,
              "difficult": false,
              "cuisine": "Italian",
              "address_line_1": "Dubai",
              "ratings_average": "4.0",
              "ratings_count": 1445
            }
          }
        }
        """.data(using: .utf8)!

        let client = MockAPIClient()
        client.result = .success(json)
        let sut = makeSUT(client: client)

        // Act
        let dto = try await sut.fetchRestaurant(id: "min")

        // Assert
        XCTAssertEqual(dto.data?.attributes?.name, "Mini")
        XCTAssertNil(dto.data?.attributes?.imageUrl)
        XCTAssertNil(dto.data?.attributes?.menuUrl)
    }

    func test_apiRequestParameters_areSetCorrectly() async throws {
        // Arrange
        let spy = SpyAPIClient()
        let sut = makeSUT(client: spy)

        // Act
        _ = try? await sut.fetchRestaurant(id: "abc-123")

        // Assert
        XCTAssertEqual(spy.capturedRequest?.path, "/consumer/v2/restaurants/abc-123")
        XCTAssertEqual(spy.capturedRequest?.method, .GET)
        XCTAssertEqual(spy.capturedRequest?.headers["Content-Type"], "application/json")
        XCTAssertTrue(spy.capturedRequest?.queryItems.isEmpty ?? false)
    }
}
