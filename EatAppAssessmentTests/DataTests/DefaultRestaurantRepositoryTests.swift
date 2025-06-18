//
//  DefaultRestaurantRepositoryTests.swift
//  EatAppAssessment
//
//  Created by Ali Bamohammad on 18/06/2025.
//

@testable import EatAppAssessment
import XCTest

final class DefaultRestaurantRepositoryTests: XCTestCase {
    private func makeSUT(api: RestaurantAPI) -> RestaurantRepository {
        DefaultRestaurantRepository(api: api)
    }

    func test_whenAPISucceeds_thenReturnsMappedRestaurants() async throws {
        // Arrange
        let dto = TestRestaurantDTOFactory.make(
            id: "api",
            name: "API Restaurant",
            cuisine: "Italian",
            imageUrl: "https://example.com/image.jpg",
            ratingsAverage: "4.2"
        )

        let api = MockRestaurantAPI()
        api.result = .success(RestaurantListResponseDTO(
            data: [dto],
            meta: PaginationMetaDTO(
                limit: 10,
                totalPages: 1,
                totalCount: 1,
                currentPage: 1
            )
        ))
        let sut = makeSUT(api: api)

        // Act
        let result = try await sut.fetchRestaurants(regionId: "some region id", page: 1, limit: 10)

        // Assert
        XCTAssertEqual(result.restaurants.count, 1)
        XCTAssertEqual(result.restaurants[0].id, "api")
        XCTAssertEqual(result.restaurants[0].name, "API Restaurant")
        XCTAssertEqual(result.restaurants[0].rating, 4.2)
        XCTAssertEqual(result.restaurants[0].cuisine, "Italian")

        // Test pagination
        XCTAssertEqual(result.pagination.currentPage, 1)
        XCTAssertEqual(result.pagination.totalPages, 1)
        XCTAssertEqual(result.pagination.totalCount, 1)
        XCTAssertEqual(result.pagination.limit, 10)
        XCTAssertFalse(result.pagination.hasNextPage)
        XCTAssertFalse(result.pagination.hasPreviousPage)
        XCTAssertTrue(result.pagination.isFirstPage)
        XCTAssertTrue(result.pagination.isLastPage)
    }

    func test_whenAPIFails_thenThrows() async {
        // Arrange
        let api = MockRestaurantAPI()
        api.result = .failure(NSError(domain: "API", code: 500))
        let sut = makeSUT(api: api)

        // Act & Assert
        await XCTAssertThrowsErrorAsync(try await sut.fetchRestaurants(regionId: "some region id", page: 1, limit: 10)) { error in
            let nsError = error as NSError
            XCTAssertEqual(nsError.domain, "API")
            XCTAssertEqual(nsError.code, 500)
        }
    }

    func test_whenRequestingSecondPage_thenParsesPaginationCorrectly() async throws {
        // Arrange
        let dto = TestRestaurantDTOFactory.make(
            id: "21",
            name: "Second Page Restaurant",
            imageUrl: "https://example.com/img2.jpg",
            ratingsAverage: "4.6"
        )

        let api = MockRestaurantAPI()
        api.result = .success(RestaurantListResponseDTO(
            data: [dto],
            meta: PaginationMetaDTO(
                limit: 10,
                totalPages: 3,
                totalCount: 25,
                currentPage: 2
            )
        ))
        let sut = makeSUT(api: api)

        // Act
        let result = try await sut.fetchRestaurants(regionId: "some region id", page: 2, limit: 10)

        // Assert
        XCTAssertEqual(result.pagination.currentPage, 2)
        XCTAssertEqual(result.pagination.totalPages, 3)
        XCTAssertEqual(result.pagination.limit, 10)
        XCTAssertEqual(result.pagination.totalCount, 25)
        XCTAssertTrue(result.pagination.hasNextPage)
        XCTAssertTrue(result.pagination.hasPreviousPage)
        XCTAssertFalse(result.pagination.isFirstPage)
        XCTAssertFalse(result.pagination.isLastPage)

        XCTAssertEqual(result.restaurants.first?.name, "Second Page Restaurant")
        XCTAssertEqual(result.restaurants.first?.rating, 4.6)
        XCTAssertEqual(result.restaurants.first?.imageUrl?.absoluteString, "https://example.com/img2.jpg")
    }

    func test_whenMultipleRestaurants_thenMapsAllCorrectly() async throws {
        // Arrange
        let dto1 = TestRestaurantDTOFactory.make(id: "1", name: "Restaurant One", imageUrl: "img1.jpg")
        let dto2 = TestRestaurantDTOFactory.make(id: "2", name: "Restaurant Two", imageUrl: "img2.jpg")
        let dto3 = TestRestaurantDTOFactory.make(id: "3", name: "Restaurant Three", imageUrl: "img3.jpg")

        let api = MockRestaurantAPI()
        api.result = .success(RestaurantListResponseDTO(
            data: [dto1, dto2, dto3],
            meta: PaginationMetaDTO(
                limit: 3,
                totalPages: 1,
                totalCount: 3,
                currentPage: 1
            )
        ))
        let sut = makeSUT(api: api)

        // Act
        let result = try await sut.fetchRestaurants(regionId: "some region id", page: 1, limit: 3)

        // Assert
        XCTAssertEqual(result.restaurants.count, 3)
        XCTAssertEqual(result.restaurants[0].name, "Restaurant One")
        XCTAssertEqual(result.restaurants[1].name, "Restaurant Two")
        XCTAssertEqual(result.restaurants[2].name, "Restaurant Three")

        // Verify all restaurants have been properly mapped
        for restaurant in result.restaurants {
            XCTAssertFalse(restaurant.name.isEmpty)
            XCTAssertNotNil(restaurant.imageUrl)
            XCTAssertGreaterThan(restaurant.rating ?? 0, 0.0)
            XCTAssertNotNil(restaurant.cuisine)
        }
    }

    func test_repositoryExtensions_work() async throws {
        // Arrange
        let dto = TestRestaurantDTOFactory.make(id: "test", name: "Test Restaurant", imageUrl: "test.jpg")
        let api = MockRestaurantAPI()
        api.result = .success(RestaurantListResponseDTO(
            data: [dto],
            meta: PaginationMetaDTO(limit: 10, totalPages: 2, totalCount: 15, currentPage: 1)
        ))
        let repository = makeSUT(api: api)

        // Test default fetch (page 1, limit 10)
        let defaultResult = try await repository.fetchRestaurants(regionId: "some region id", page: 1, limit: 9)
        XCTAssertEqual(defaultResult.pagination.currentPage, 1)
        XCTAssertEqual(defaultResult.pagination.limit, 10)
    }
}
