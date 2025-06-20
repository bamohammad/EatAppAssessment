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
    private var mockRepository: MockRestaurantRepository!

    override func setUp() {
        super.setUp()

        // Reset and register fresh mock
        DIContainer.shared.reset()

        mockRepository = MockRestaurantRepository()
        DIContainer.shared.register(RestaurantRepository.self) { [unowned self] in
            mockRepository
        }

        DIContainer.shared.register(GetRestaurantsUseCase.self) {
            DefaultGetRestaurantsUseCase(
                repository: DIContainer.shared.resolve(RestaurantRepository.self)
            )
        }
    }

    override func tearDown() {
        mockRepository = nil
        super.tearDown()
    }

    private func makeSUT() -> GetRestaurantsUseCase {
        DIContainer.shared.resolve(GetRestaurantsUseCase.self)
    }

    func test_whenRepositorySucceeds_thenReturnsRequestedPage() async throws {
        // Arrange
        let restaurants = (1...25).map {
            TestRestaurantFactory.make(id: "\($0)", name: $0 == 21 ? "A" : "R\($0)")
        }
        mockRepository.valuesToEmit = restaurants
        let sut = makeSUT()
        let page = 3
        let limit = 10

        // Act
        let result = try await sut.execute(regionId: regionId, page: page, limit: limit)

        // Assert
        XCTAssertEqual(result.pagination.currentPage, page)
        XCTAssertEqual(result.pagination.totalPages, 3)
        XCTAssertEqual(result.restaurants.first?.name, "A")
        XCTAssertEqual(mockRepository.recordedRequests.first?.page, page)
        XCTAssertEqual(mockRepository.recordedRequests.first?.limit, limit)
    }

    func test_whenRepositoryFails_thenThrowsError() async {
        // Arrange
        mockRepository.errorPages = [1]
        let sut = makeSUT()

        // Act & Assert
        await XCTAssertThrowsErrorAsync(try await sut.execute(regionId: regionId, page: 1, limit: 10)) { error in
            let nsError = error as NSError
            XCTAssertEqual(nsError.domain, "MockError")
            XCTAssertEqual(nsError.code, 1)
        }
    }
}

