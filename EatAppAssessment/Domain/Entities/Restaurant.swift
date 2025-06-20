//
//  Restaurant.swift
//  EatAppAssessment
//
//  Created by Ali Bamohammad on 18/06/2025.
//


import Foundation

struct RestaurantList: Equatable {
    let restaurants: [Restaurant]
    let pagination: PaginationInfo
}

struct Restaurant: Identifiable, Equatable {
    let id: String
    let name: String
    let cuisine: String
    let priceLevel: PriceLevel
    let rating: Double
    let reviewCount: Int
    let imageUrl: URL?
    let location: RestaurantBasicLocation?
}

struct RestaurantBasicLocation: Equatable {
    let latitude: Double
    let longitude: Double
    let address: String
}

struct PaginationInfo: Equatable {
    let limit: Int
    let totalPages: Int
    let totalCount: Int
    let currentPage: Int
    
    var hasNextPage: Bool {
        currentPage < totalPages
    }
    
    var hasPreviousPage: Bool {
        currentPage > 1
    }
    
    var isFirstPage: Bool {
        currentPage == 1
    }
    
    var isLastPage: Bool {
        currentPage == totalPages
    }
}
