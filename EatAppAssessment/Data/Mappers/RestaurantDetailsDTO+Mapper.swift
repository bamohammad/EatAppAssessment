//
//  RestaurantDTO+Mapper.swift
//  EatAppAssessment
//
//  Created by Ali Bamohammad on 18/06/2025.
//

import Foundation

extension RestaurantDetails {
    init(from dto: RestaurantResponseDTO?) {
        let restaurantData = dto?.data
        let attributes = restaurantData?.attributes

        id = restaurantData?.id ?? ""
        name = attributes?.name ?? ""
        cuisine = attributes?.cuisine ?? ""
        priceLevel = PriceLevel(rawValue: attributes?.priceLevel ?? 0) ?? .moderate
        rating = Double(attributes?.ratingsAverage ?? "0.0") ?? 0.0
        reviewCount = attributes?.ratingsCount ?? 0
        imageUrl = URL(string: attributes?.imageUrl ?? "")
        location = RestaurantLocation(
            latitude: attributes?.latitude ?? 0.0,
            longitude: attributes?.longitude ?? 0.0,
            address: Address(
                line1: attributes?.addressLine1 ?? "",
                line2: attributes?.addressLine2 ?? "",
                city: attributes?.city ?? "",
                province: attributes?.province ?? "",
                postalCode: attributes?.postalCode ?? ""
            ),
            neighborhood: attributes?.neighborhoodName ?? ""
        )

        description = attributes?.description ?? ""
        notice = attributes?.notice
        labels = attributes?.labels?.compactMap { RestaurantLabel(rawValue: $0) } ?? []
    }
}

extension RestaurantDetails {
    /// Formatted rating string
    var formattedRating: String {
        String(format: "%.1f", rating)
    }

    /// Rating with review count
    var ratingWithCount: String {
        "\(formattedRating) (\(String(describing: reviewCount)) reviews)"
    }
}
