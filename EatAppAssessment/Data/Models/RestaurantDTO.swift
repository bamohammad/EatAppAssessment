//
//  RestaurantDTO.swift
//  EatAppAssessment
//
//  Created by Ali Bamohammad on 18/06/2025.
//


import Foundation

struct RestaurantListResponseDTO: Codable {
    let data: [RestaurantListItemDTO]?
    let meta: PaginationMetaDTO?
}

struct RestaurantListItemDTO: Codable {
    let id: String?
    let type: String?
    let attributes: RestaurantListAttributesDTO?
    let relationships: RestaurantListRelationshipsDTO?
}

struct RestaurantListAttributesDTO: Codable {
    let name: String?
    let priceLevel: Int?
    let phone: String?
    let menuUrl: String?
    let requireBookingPreferenceEnabled: Bool?
    let difficult: Bool?
    let cuisine: String?
    let imageUrl: String?
    let latitude: Double?
    let longitude: Double?
    let addressLine1: String?
    let ratingsAverage: String?
    let ratingsCount: Int?
    let labels: [String]?
    
    enum CodingKeys: String, CodingKey {
        case name
        case priceLevel = "price_level"
        case phone
        case menuUrl = "menu_url"
        case requireBookingPreferenceEnabled = "require_booking_preference_enabled"
        case difficult
        case cuisine
        case imageUrl = "image_url"
        case latitude
        case longitude
        case addressLine1 = "address_line_1"
        case ratingsAverage = "ratings_average"
        case ratingsCount = "ratings_count"
        case labels
    }
}

struct RestaurantListRelationshipsDTO: Codable {
    let region: RelationshipDataDTO?
}

struct PaginationMetaDTO: Codable {
    let limit: Int?
    let totalPages: Int?
    let totalCount: Int?
    let currentPage: Int?
    
    enum CodingKeys: String, CodingKey {
        case limit
        case totalPages = "total_pages"
        case totalCount = "total_count"
        case currentPage = "current_page"
    }
}

struct PaginationLinksDTO: Codable {
    let first: String?
    let next: String?
    let prev: String?
    let last: String?
}
