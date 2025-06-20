//
//  RestaurantRepository.swift
//  EatAppAssessment
//
//  Created by Ali Bamohammad on 18/06/2025.
//


import Foundation

protocol RestaurantRepository {
    func fetchRestaurants(search:String, regionId: String,page: Int, limit: Int) async throws -> RestaurantList
}
