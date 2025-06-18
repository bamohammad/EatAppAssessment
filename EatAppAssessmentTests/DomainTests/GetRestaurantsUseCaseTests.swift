//
//  GetRestaurantsUseCaseTests.swift
//  EatAppAssessment
//
//  Created by Ali Bamohammad on 18/06/2025.
//

@testable import EatAppAssessment
import XCTest

@MainActor
final class GetRestaurantsUseCaseTests: XCTestCase {

    private let regionId = "3906535a-d96c-47cf-99b0-009fc9e038e0"
    private func makeSUT(repo: RestaurantRepository) -> GetRestaurantsUseCase {
        DefaultGetRestaurantsUseCase(repository: repo)
    }

    func test_whenRepositorySucceeds_thenReturnsRequestedPage() async throws {
        // Arrange
        let restaurants = (1...25).map {
            TestRestaurantFactory.make(id: "\($0)", name: $0 == 21 ? "A" : "R\($0)")
        }
        let repo = MockRestaurantRepository()
        repo.valuesToEmit = restaurants
        let sut = makeSUT(repo: repo)
        let page = 3
        let limit = 10

        // Act
        let result = try await sut.execute(regionId: regionId, page: page, limit: limit)

        // Assert
        XCTAssertEqual(result.pagination.currentPage, page)
        XCTAssertEqual(result.pagination.totalPages, 3)
        XCTAssertEqual(result.restaurants.first?.name, "A")
        XCTAssertEqual(repo.recordedRequests.first?.page, page)
        XCTAssertEqual(repo.recordedRequests.first?.limit, limit)
    }

    func test_whenRepositoryFails_thenThrowsError() async {
        // Arrange
        let repo = MockRestaurantRepository()
        repo.errorPages = [1]
        let sut = makeSUT(repo: repo)

        // Act & Assert
        await XCTAssertThrowsErrorAsync(try await sut.execute(regionId: regionId, page: 1, limit: 10)) { error in
            let nsError = error as NSError
            XCTAssertEqual(nsError.domain, "MockError")
            XCTAssertEqual(nsError.code, 1)
        }
    }
}
