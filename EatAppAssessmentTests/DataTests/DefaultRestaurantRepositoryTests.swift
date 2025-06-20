//
//  DefaultRestaurantRepositoryTests.swift
//  EatAppAssessment
//
//  Created by Ali Bamohammad on 18/06/2025.
//

@testable import EatAppAssessment
import XCTest

@MainActor
final class DefaultRestaurantRepositoryTests: XCTestCase {

    private var mockAPI: MockRestaurantAPI!

    override func setUp() {
        super.setUp()

        DIContainer.shared.reset()

        mockAPI = MockRestaurantAPI()
        DIContainer.shared.register(RestaurantAPI.self) { [unowned self] in
            mockAPI
        }

        DIContainer.shared.register(RestaurantRepository.self) {
            DefaultRestaurantRepository(api: DIContainer.shared.resolve(RestaurantAPI.self))
        }
    }

    override func tearDown() {
        mockAPI = nil
        super.tearDown()
    }

    private func makeSUT() -> RestaurantRepository {
        DIContainer.shared.resolve(RestaurantRepository.self)
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

        mockAPI.result = .success(RestaurantListResponseDTO(
            data: [dto],
            meta: .init(limit: 10, totalPages: 1, totalCount: 1, currentPage: 1)
        ))

        let sut = makeSUT()

        // Act
        let result = try await sut.fetchRestaurants(regionId: "some region id", page: 1, limit: 10)

        // Assert
        XCTAssertEqual(result.restaurants.count, 1)
        XCTAssertEqual(result.restaurants[0].id, "api")
        XCTAssertEqual(result.restaurants[0].name, "API Restaurant")
        XCTAssertEqual(result.restaurants[0].rating, 4.2)
        XCTAssertEqual(result.restaurants[0].cuisine, "Italian")

        // Pagination checks
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
        mockAPI.result = .failure(NSError(domain: "API", code: 500))
        let sut = makeSUT()

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

        mockAPI.result = .success(RestaurantListResponseDTO(
            data: [dto],
            meta: .init(limit: 10, totalPages: 3, totalCount: 25, currentPage: 2)
        ))

        let sut = makeSUT()

        // Act
        let result = try await sut.fetchRestaurants(regionId: "some region id", page: 2, limit: 10)

        // Assert
        XCTAssertEqual(result.pagination.currentPage, 2)
        XCTAssertEqual(result.pagination.totalPages, 3)
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

        mockAPI.result = .success(RestaurantListResponseDTO(
            data: [dto1, dto2, dto3],
            meta: .init(limit: 3, totalPages: 1, totalCount: 3, currentPage: 1)
        ))

        let sut = makeSUT()

        // Act
        let result = try await sut.fetchRestaurants(regionId: "some region id", page: 1, limit: 3)

        // Assert
        XCTAssertEqual(result.restaurants.count, 3)
        XCTAssertEqual(result.restaurants[0].name, "Restaurant One")
        XCTAssertEqual(result.restaurants[1].name, "Restaurant Two")
        XCTAssertEqual(result.restaurants[2].name, "Restaurant Three")

        for restaurant in result.restaurants {
            XCTAssertFalse(restaurant.name.isEmpty)
            XCTAssertNotNil(restaurant.imageUrl)
            XCTAssertGreaterThan(restaurant.rating, 0.0)
            XCTAssertNotNil(restaurant.cuisine)
        }
    }

    func test_repositoryExtensions_work() async throws {
        // Arrange
        let dto = TestRestaurantDTOFactory.make(id: "test", name: "Test Restaurant", imageUrl: "test.jpg")

        mockAPI.result = .success(RestaurantListResponseDTO(
            data: [dto],
            meta: .init(limit: 10, totalPages: 2, totalCount: 15, currentPage: 1)
        ))

        let sut = makeSUT()

        // Act
        let result = try await sut.fetchRestaurants(regionId: "some region id", page: 1, limit: 9)

        // Assert
        XCTAssertEqual(result.pagination.currentPage, 1)
        XCTAssertEqual(result.pagination.limit, 10)
    }
}

