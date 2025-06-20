//
//  RestaurantListViewModelTests.swift
//  EatAppAssessment
//
//  Created by Ali Bamohammad on 19/06/2025.
//

import Combine
@testable import EatAppAssessment
import XCTest

@MainActor
final class RestaurantListViewModelTests: XCTestCase {

    private var mockUseCase: MockGetRestaurantsUseCase!
    private var cancellables = Set<AnyCancellable>()

    // MARK: - Bootstrap
    override func setUp() {
        super.setUp()

        DIContainer.shared.reset()

        mockUseCase = MockGetRestaurantsUseCase()

        DIContainer.shared.register(GetRestaurantsUseCase.self) { [unowned self] in
            mockUseCase
        }

        
        DIContainer.shared.register(RestaurantListViewModel.self) {
            RestaurantListViewModel(
                useCase: DIContainer.shared.resolve(GetRestaurantsUseCase.self)
            )
        }
    }

    override func tearDown() {
        mockUseCase = nil
        cancellables.removeAll()
        super.tearDown()
    }

    private func makeSUT() -> RestaurantListViewModel {
        DIContainer.shared.resolve(RestaurantListViewModel.self)
    }

    // MARK: - 1. First-page success
    func test_loadFirstPage_success_setsLoadedState() async {
        // Arrange
        let item = TestRestaurantFactory.make(id: "1")
        mockUseCase.stubbedPages = [
            1: RestaurantList(
                restaurants: [item],
                pagination: .init(limit: 10, totalPages: 1, totalCount: 1, currentPage: 1)
            )
        ]
        let sut = makeSUT()

        // Act
        let final = await expectFinalLoadableValue(sut.$state) { sut.loadFirstPage() }

        // Assert
        guard case .loaded(let list) = final else { return XCTFail("Expected loaded") }
        XCTAssertEqual(list, [item])
    }

    // MARK: - 2. Pagination appends
    func test_loadNextPage_appendsItems() async {
        // Arrange
        let r1 = TestRestaurantFactory.make(id: "A")
        let r2 = TestRestaurantFactory.make(id: "B")
        mockUseCase.stubbedPages = [
            1: .init(
                restaurants: [r1],
                pagination: .init(limit: 10, totalPages: 2, totalCount: 2, currentPage: 1)
            ),
            2: .init(
                restaurants: [r2],
                pagination: .init(limit: 10, totalPages: 2, totalCount: 2, currentPage: 2)
            )
        ]
        let sut = makeSUT()

        // Act
        await expectFinalLoadableValue(sut.$state) { sut.loadFirstPage() }
        let final = await expectFinalLoadableValue(sut.$state) {
            sut.loadNextPageIfNeeded(currentItem: r1)
        }

        // Assert
        guard case .loaded(let list) = final else { return XCTFail("Expected loaded") }
        XCTAssertEqual(list, [r1, r2])
    }

    // MARK: - 3. Duplicate-call guard
    func test_loadNextPage_whileLoading_ignoresSecondRequest() async throws {
        // Arrange
        let first = TestRestaurantFactory.make(id: "X")
        mockUseCase.stubbedPages = [
            1: .init(
                restaurants: [first],
                pagination: .init(limit: 10, totalPages: 2, totalCount: 2, currentPage: 1)
            ),
            2: .init(
                restaurants: [],
                pagination: .init(limit: 10, totalPages: 2, totalCount: 2, currentPage: 2)
            )
        ]
        mockUseCase.delayPages.insert(2) // simulate slow page-2
        let sut = makeSUT()

        // Act
        await expectFinalLoadableValue(sut.$state) { sut.loadFirstPage() }
        sut.loadNextPageIfNeeded(currentItem: first)
        sut.loadNextPageIfNeeded(currentItem: first)
        try await Task.sleep(nanoseconds: 120_000_000)

        // Assert
        XCTAssertEqual(mockUseCase.recordedRequests.filter { $0.0 == 2 }.count, 1)
    }

    // MARK: - 4. Failure path
    func test_loadFirstPage_failure_setsFailedState() async {
        // Arrange
        mockUseCase.error = NSError(domain: "Test", code: -1)
        let sut = makeSUT()

        // Act
        let final = await expectFinalLoadableValue(sut.$state) { sut.loadFirstPage() }

        // Assert
        if case .failed = final { XCTAssertTrue(true) } else { XCTFail("Expected failed") }
    }
}

