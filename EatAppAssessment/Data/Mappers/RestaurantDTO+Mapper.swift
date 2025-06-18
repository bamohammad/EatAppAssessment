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
        cuisine = attributes?.cuisine
        priceLevel = PriceLevel(rawValue: attributes?.priceLevel ?? 0) ?? .moderate
        rating = Double(attributes?.ratingsAverage ?? "0") ?? 0.0
        reviewCount = attributes?.ratingsCount
        imageUrl = URL(string: attributes?.imageUrl ?? "")
        location = RestaurantBasicLocation(
            latitude: attributes?.latitude,
            longitude: attributes?.longitude,
            address: attributes?.addressLine1
        )
        contact = RestaurantBasicContact(
            phone: attributes?.phone,
            menuUrl: attributes?.menuUrl.flatMap { URL(string: $0) }
        )
        labels = attributes?.labels?.compactMap { RestaurantLabel(rawValue: $0) }
        isBookingRequired = attributes?.requireBookingPreferenceEnabled
        isDifficultToBook = attributes?.difficult
        regionId = dto.relationships?.region?.data?.id 
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
    /// Grouped labels by category for better UI organization
    var labelsByCategory: [LabelCategory: [RestaurantLabel]] {
        Dictionary(grouping: labels ?? [], by: \.category)
    }

    /// Quick access to dress code labels
    var dressCodeLabels: [RestaurantLabel] {
        labels?.filter { $0.category == .dressCode } ?? []
    }

    /// Quick access to meal time labels
    var mealTimeLabels: [RestaurantLabel] {
        labels?.filter { $0.category == .mealTime } ?? []
    }

    /// Quick access to dietary labels
    var dietaryLabels: [RestaurantLabel] {
        labels?.filter { $0.category == .dietary } ?? []
    }

    /// Formatted rating string
    var formattedRating: String {
        String(format: "%.1f", rating ?? 0.0)
    }

    /// Rating with review count
    var ratingWithCount: String {
        "\(formattedRating) (\(String(describing: reviewCount)) reviews)"
    }
}

extension PaginationInfo {
    /// Calculate page range for pagination UI
    func pageRange(around currentPage: Int, maxVisible: Int = 5) -> ClosedRange<Int> {
        let halfVisible = maxVisible / 2
        let start = max(1, currentPage - halfVisible)
        let end = min(totalPages, start + maxVisible - 1)
        let adjustedStart = max(1, end - maxVisible + 1)

        return adjustedStart ... end
    }
}
