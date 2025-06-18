//
//  GetRestaurantsUseCase.swift
//  EatAppAssessment
//
//  Created by Ali Bamohammad on 18/06/2025.
//

import Foundation

protocol GetRestaurantsUseCase {
    func execute(
        regionId: String,
        page: Int,
        limit: Int
    ) async throws -> RestaurantList
}

final class DefaultGetRestaurantsUseCase: GetRestaurantsUseCase {
    private let repository: RestaurantRepository

    init(repository: RestaurantRepository) {
        self.repository = repository
    }

    func execute(
        regionId: String,
        page: Int,
        limit: Int
    ) async throws -> RestaurantList {
        return try await repository.fetchRestaurants(
            regionId: regionId,
            page: page,
            limit: limit
        )
    }
}
