//
//  RestaurantDetailsRepository.swift
//  EatAppAssessment
//
//  Created by Ali Bamohammad on 19/06/2025.
//


protocol RestaurantDetailsRepository {
    func fetchRestaurant(id:String) async throws -> RestaurantDetails
}
