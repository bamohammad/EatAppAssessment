//
//  DefaultRestaurantDetailsRepository.swift
//  EatAppAssessment
//
//  Created by Ali Bamohammad on 19/06/2025.
//


final class DefaultRestaurantDetailsRepository: RestaurantDetailsRepository {
    private let api: RestaurantDetailsAPI

    init(api: RestaurantDetailsAPI) {
        self.api = api
    }

    func fetchRestaurant(id:String) async throws -> RestaurantDetails {
        do {
            let dto = try await api.fetchRestaurant(id: id)
            return RestaurantDetails(from: dto)
        } catch {
            throw error
        }
    }
}
