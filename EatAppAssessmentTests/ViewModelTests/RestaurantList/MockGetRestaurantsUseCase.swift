//
//  MockGetRestaurantsUseCase.swift
//  EatAppAssessment
//
//  Created by Ali Bamohammad on 19/06/2025.
//


import Foundation
@testable import EatAppAssessment

final class MockGetRestaurantsUseCase: GetRestaurantsUseCase {
    var stubbedPages: [Int: RestaurantList] = [:]
    var error: Error?
    var delayPages: Set<Int> = []
    private(set) var recordedRequests: [(Int, Int)] = []

    func execute(regionId: String, page: Int, limit: Int) async throws -> RestaurantList {
        recordedRequests.append((page, limit))
        if let error { throw error }
        if delayPages.contains(page) { try? await Task.sleep(nanoseconds: 300_000_000) }
        guard let res = stubbedPages[page] else {
            throw NSError(domain: "NoStub", code: page)
        }
        return res
    }
}

