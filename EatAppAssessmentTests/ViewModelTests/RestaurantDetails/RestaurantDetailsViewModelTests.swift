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
    private var mockUseCase: MockGetRestaurantDetailsUseCase!

    override func setUp() {
        super.setUp()
        DIContainer.shared.reset()
        mockUseCase = MockGetRestaurantDetailsUseCase()

        DIContainer.shared.register(GetRestaurantDetailsUseCase.self) { [unowned self] in
            mockUseCase
        }

        DIContainer.shared.register(RestaurantDetailsViewModel.self) {
            RestaurantDetailsViewModel(
                useCase: DIContainer.shared.resolve(GetRestaurantDetailsUseCase.self)
            )
        }
    }

    override func tearDown() {
        mockUseCase = nil
        cancellables.removeAll()
        super.tearDown()
    }

    private func makeSUT() -> RestaurantDetailsViewModel {
        DIContainer.shared.resolve(RestaurantDetailsViewModel.self)
    }

    func test_loadDetails_success_setsLoadedState() async {
        // Arrange
        let expected = TestRestaurantFactory.makeDetails(id: "123")
        mockUseCase.stubbedResult = expected
        let sut = makeSUT()

        // Act
        let final = await expectFinalLoadableValue(sut.$state) {
            sut.loadDetails(for: "123")
        }

        // Assert
        guard case let .loaded(details) = final else {
            return XCTFail("Expected loaded state")
        }
        XCTAssertEqual(details, expected)
    }

    func test_loadDetails_failure_setsFailedState() async {
        // Arrange
        mockUseCase.error = NSError(domain: "Test", code: -1)
        let sut = makeSUT()

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

