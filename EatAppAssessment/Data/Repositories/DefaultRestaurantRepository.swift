//
//  DefaultRestaurantRepository.swift
//  EatAppAssessment
//
//  Created by Ali Bamohammad on 18/06/2025.
//

final class DefaultRestaurantRepository: RestaurantRepository {
    private let api: RestaurantAPI

    init(api: RestaurantAPI) {
        self.api = api
    }

    func fetchRestaurants(search: String, regionId: String, page: Int, limit: Int) async throws -> RestaurantList {
        let dto = try await api.fetchRestaurants(search: search, regionId: regionId, page: page, limit: limit)
        return RestaurantList(from: dto)
    }
}
