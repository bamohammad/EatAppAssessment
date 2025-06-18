//
//  RestaurantDetailsViewModelTests.swift
//  EatAppAssessment
//
//  Created by Ali Bamohammad on 19/06/2025.
//

import Combine
@testable import EatAppAssessment
import XCTest

@MainActor
final class RestaurantDetailsViewModelTests: XCTestCase {
    private var cancellables = Set<AnyCancellable>()

    private func makeSUT(useCase: MockGetRestaurantDetailsUseCase) -> RestaurantDetailsViewModel {
        RestaurantDetailsViewModel(useCase: useCase)
    }

    func test_loadDetails_success_setsLoadedState() async {
        // Arrange
        let expected = TestRestaurantFactory.makeDetails(id: "123")
        let mock = MockGetRestaurantDetailsUseCase()
        mock.stubbedResult = expected
        let sut = makeSUT(useCase: mock)

        // Act
        let final = await expectFinalLoadableValue(sut.$state) {
            sut.loadDetails(for: "123")
        }

        // Assert
        guard case let .loaded(details) = final else {
            return XCTFail("Expected loaded")
        }
        XCTAssertEqual(details, expected)
    }

    func test_loadDetails_failure_setsFailedState() async {
        // Arrange
        let mock = MockGetRestaurantDetailsUseCase()
        mock.error = NSError(domain: "Test", code: -1)
        let sut = makeSUT(useCase: mock)

        // Act
        let final = await expectFinalLoadableValue(sut.$state) {
            sut.loadDetails(for: "xyz")
        }

        // Assert
        if case .failed = final {
            XCTAssertTrue(true)
        } else {
            XCTFail("Expected failed state")
        }
    }
}
