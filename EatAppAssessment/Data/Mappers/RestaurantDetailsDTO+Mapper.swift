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
        contact = RestaurantContact(
            phone: attributes?.phone,
            menuUrl: attributes?.menuUrl.flatMap { URL(string: $0) },
            externalRatingsUrl: URL(string: attributes?.externalRatingsUrl ?? "")
        )
        features = RestaurantFeatures(
            hasAlcohol: attributes?.alcohol ?? false,
            hasOutdoorSeating: attributes?.outdoorSeating ?? false,
            allowsSmoking: attributes?.smoking ?? false,
            hasValet: attributes?.valet ?? false,
            acceptsBookings: attributes?.requireBookingPreferenceEnabled == false,
            isDifficultToBook: attributes?.difficult ?? false
        )
        operatingHours = OperatingHours(rawHours: attributes?.operatingHours ?? "")
        description = attributes?.description ?? ""
        notice = attributes?.notice
        establishmentType = EstablishmentType(rawValue: attributes?.establishmentType ?? "") ?? .casualDining
        labels = attributes?.labels?.compactMap { RestaurantLabel(rawValue: $0) } ?? []
    }
}

extension Review {
    init?(from dto: ReviewDTO) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"

        guard let date = formatter.date(from: dto.publishedDate ?? "") else {
            return nil
        }

        id = dto.url ?? "" // Using URL as ID since there's no unique ID in the DTO
        title = dto.title ?? ""
        text = dto.text ?? ""
        rating = dto.rating ?? 0
        publishedDate = date
        author = ReviewAuthor(
            username: dto.user?.username ?? "",
            location: dto.user?.userLocation?.name ?? ""
        )
        url = URL(string: dto.url ?? "")
    }
}
