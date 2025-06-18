//
//  GetRestaurantDetailsUseCase.swift
//  EatAppAssessment
//
//  Created by Ali Bamohammad on 19/06/2025.
//


import Foundation

protocol GetRestaurantDetailsUseCase {
    func execute(id:String) async throws -> RestaurantDetails
}

final class DefaultGetRestaurantDetailsUseCase: GetRestaurantDetailsUseCase {
    private let repository: RestaurantDetailsRepository

    init(repository: RestaurantDetailsRepository) {
        self.repository = repository
    }

    func execute(id:String) async throws -> RestaurantDetails {
        return try await repository.fetchRestaurant(id: id)
    }
}