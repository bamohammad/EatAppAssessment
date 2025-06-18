//
//  MockGetRestaurantDetailsUseCase.swift
//  EatAppAssessment
//
//  Created by Ali Bamohammad on 19/06/2025.
//
import Foundation
@testable import EatAppAssessment

final class MockGetRestaurantDetailsUseCase: GetRestaurantDetailsUseCase {
    var stubbedResult: RestaurantDetails?
    var error: Error?

    func execute(id: String) async throws -> RestaurantDetails {
        if let error = error { throw error }
        guard let result = stubbedResult else {
            throw NSError(domain: "NoStub", code: -1)
        }
        return result
    }
}
