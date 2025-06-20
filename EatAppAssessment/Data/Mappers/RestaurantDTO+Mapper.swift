//
//  RestaurantDTO+Mapper.swift
//  EatAppAssessment
//
//  Created by Ali Bamohammad on 18/06/2025.
//

import Foundation

extension RestaurantList {
    init(from dto: RestaurantListResponseDTO) {
        restaurants = dto.data?.map { Restaurant(from: $0) } ?? []
        pagination = PaginationInfo(from: dto.meta)
    }
}

extension Restaurant {
    init(from dto: RestaurantListItemDTO) {
        let attributes = dto.attributes

        id = dto.id ?? ""
        name = attributes?.name ?? ""
        cuisine = attributes?.cuisine ?? ""
        priceLevel = PriceLevel(rawValue: attributes?.priceLevel ?? 0) ?? .moderate
        rating = Double(attributes?.ratingsAverage ?? "0") ?? 0.0
        reviewCount = attributes?.ratingsCount ?? 0
        imageUrl = URL(string: attributes?.imageUrl ?? "")
        location = RestaurantBasicLocation(
            latitude: attributes?.latitude ?? 0,
            longitude: attributes?.longitude ?? 0,
            address: attributes?.addressLine1 ?? ""
        )
    }
}

extension PaginationInfo {
    init(from dto: PaginationMetaDTO?) {
        limit = dto?.limit ?? 30
        totalPages = dto?.totalPages ?? Int.max
        totalCount = dto?.totalCount ?? Int.max
        currentPage = dto?.currentPage ?? 1
    }
}

// MARK: - Helper Extensions

extension Restaurant {
    /// Formatted rating string
    var formattedRating: String {
        String(format: "%.1f", rating)
    }

    /// Rating with review count
    var ratingWithCount: String {
        "\(formattedRating) (\(String(describing: reviewCount)) reviews)"
    }
}
