//
//  XCTest+Async.swift
//  EatAppAssessment
//
//  Created by Ali Bamohammad on 18/06/2025.
//

import Combine
import XCTest
@testable import EatAppAssessment

extension XCTestCase {
    /// Awaits the first non‑initial value published after an action.
    @discardableResult
    func expectPublished<T: Publisher>(
        _ publisher: T,
        after action: () -> Void,
        file: StaticString = #file,
        line: UInt = #line
    ) async -> T.Output where T.Failure == Never {
        let expectation = XCTestExpectation(description: "Value published")
        var output: T.Output!

        let cancellable = publisher.dropFirst().sink { value in
            output = value
            expectation.fulfill()
        }

        action()
        await fulfillment(of: [expectation], timeout: 1)
        cancellable.cancel()
        return output
    }
    /// Awaits the first non‑initial value published after an action for Loadable.
    @discardableResult
       func expectFinalLoadableValue<T>(
           _ publisher: Published<Loadable<T>>.Publisher,
           after action: () -> Void,
           timeout: TimeInterval = 2,
           file: StaticString = #file,
           line: UInt = #line
       ) async -> Loadable<T> {
           let expectation = XCTestExpectation(description: "Loaded or failed state emitted")
           var output: Loadable<T>?

           let cancellable = publisher
               .dropFirst()
               .sink { value in
                   switch value {
                   case .loaded, .failed:
                       output = value
                       expectation.fulfill()
                   default: break
                   }
               }

           action()
           await fulfillment(of: [expectation], timeout: timeout)
           cancellable.cancel()

           if let output {
               return output
           } else {
               XCTFail("No final state emitted", file: file, line: line)
               return .idle
           }
       }

    func XCTAssertThrowsErrorAsync<T>(
        _ expression: @autoclosure () async throws -> T,
        _ message: @autoclosure () -> String = "",
        file: StaticString = #filePath,
        line: UInt = #line,
        _ errorHandler: (_ error: Error) -> Void = { _ in }
    ) async {
        do {
            _ = try await expression()
            XCTFail("Expected expression to throw an error", file: file, line: line)
        } catch {
            errorHandler(error)
        }
    }
}
