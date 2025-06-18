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
    let cuisine: String?
    let priceLevel: PriceLevel?
    let rating: Double?
    let reviewCount: Int?
    let imageUrl: URL?
    let location: RestaurantBasicLocation?
    let contact: RestaurantBasicContact?
    let labels: [RestaurantLabel]?
    let isBookingRequired: Bool?
    let isDifficultToBook: Bool?
    let regionId: String?
}

struct RestaurantBasicLocation: Equatable {
    let latitude: Double?
    let longitude: Double?
    let address: String?
}

struct RestaurantBasicContact: Equatable {
    let phone: String?
    let menuUrl: URL?
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

struct PaginationLinks: Equatable {
    let first: URL?
    let next: URL?
    let previous: URL?
    let last: URL?
}

enum LabelCategory: String, CaseIterable {
    case dressCode = "Dress Code"
    case audience = "Good For"
    case mealTime = "Meal Times"
    case dietary = "Dietary"
    case payment = "Payment"
    case atmosphere = "Atmosphere"
    
    var systemImage: String {
        switch self {
        case .dressCode: return "tshirt"
        case .audience: return "person.3"
        case .mealTime: return "clock"
        case .dietary: return "leaf"
        case .payment: return "creditcard"
        case .atmosphere: return "sparkles"
        }
    }
}
