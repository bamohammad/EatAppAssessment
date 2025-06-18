//
//  RestaurantListViewModelTests.swift
//  EatAppAssessment
//
//  Created by Ali Bamohammad on 19/06/2025.
//

import XCTest
import Combine
@testable import EatAppAssessment

@MainActor
final class RestaurantListViewModelTests: XCTestCase {

    private var cancellables = Set<AnyCancellable>()

    // MARK: - Factory
    private func makeSUT(useCase: MockGetRestaurantsUseCase) -> RestaurantListViewModel {
        RestaurantListViewModel(useCase: useCase)
    }

    // MARK: - 1. First-page success
    func test_loadFirstPage_success_setsLoadedState() async {
        let item = TestRestaurantFactory.make(id: "1")

        let mock = MockGetRestaurantsUseCase()
        mock.stubbedPages = [
            1: RestaurantList(
                restaurants: [item],
                pagination: .init(limit: 10, totalPages: 1, totalCount: 1, currentPage: 1)
            )
        ]
        let sut = makeSUT(useCase: mock)

        let final = await expectFinalLoadableValue(sut.$state) { sut.loadFirstPage() }

        guard case .loaded(let list) = final else { return XCTFail("Expected loaded") }
        XCTAssertEqual(list, [item])
    }

    // MARK: - 2. Pagination appends
    func test_loadNextPage_appendsItems() async {
        let r1 = TestRestaurantFactory.make(id: "A")
        let r2 = TestRestaurantFactory.make(id: "B")

        let mock = MockGetRestaurantsUseCase()
        mock.stubbedPages = [
            1: .init(restaurants: [r1],
                     pagination: .init(limit: 10, totalPages: 2, totalCount: 2, currentPage: 1)),
            2: .init(restaurants: [r2],
                     pagination: .init(limit: 10, totalPages: 2, totalCount: 2, currentPage: 2))
        ]
        let sut = makeSUT(useCase: mock)

        await expectFinalLoadableValue(sut.$state) { sut.loadFirstPage() }
        let final = await expectFinalLoadableValue(sut.$state) {
            sut.loadNextPageIfNeeded(currentItem: r1)
        }

        guard case .loaded(let list) = final else { return XCTFail("Expected loaded") }
        XCTAssertEqual(list, [r1, r2])
    }

    // MARK: - 3. Duplicate-call guard
    func test_loadNextPage_whileLoading_ignoresSecondRequest() async {
        let first = TestRestaurantFactory.make(id: "X")

        let mock = MockGetRestaurantsUseCase()
        mock.stubbedPages = [
            1: .init(restaurants: [first],
                     pagination: .init(limit: 10, totalPages: 2, totalCount: 2, currentPage: 1)),
            2: .init(restaurants: [],
                     pagination: .init(limit: 10, totalPages: 2, totalCount: 2, currentPage: 2))
        ]
        mock.delayPages.insert(2)   // simulate slow page-2
        let sut = makeSUT(useCase: mock)

        await expectFinalLoadableValue(sut.$state) { sut.loadFirstPage() }

        sut.loadNextPageIfNeeded(currentItem: first)
        sut.loadNextPageIfNeeded(currentItem: first)

        try? await Task.sleep(nanoseconds: 120_000_000)
        XCTAssertEqual(mock.recordedRequests.filter { $0.0 == 2 }.count, 1)
    }

    // MARK: - 4. Failure path
    func test_loadFirstPage_failure_setsFailedState() async {
        let mock = MockGetRestaurantsUseCase()
        mock.error = NSError(domain: "Test", code: -1)
        let sut = makeSUT(useCase: mock)

        let final = await expectFinalLoadableValue(sut.$state) { sut.loadFirstPage() }

        if case .failed = final { XCTAssertTrue(true) } else { XCTFail("Expected failed") }
    }
}
