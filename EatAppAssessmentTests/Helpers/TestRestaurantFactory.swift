//
//  TestRestaurantFactory.swift
//  EatAppAssessment
//
//  Created by Ali Bamohammad on 18/06/2025.
//
@testable import EatAppAssessment
import Foundation

enum TestRestaurantFactory {
    static func make(
        id: String = UUID().uuidString,
        name: String = "Mock Restaurant",
        cuisine: String = "Test Cuisine",
        priceLevel: PriceLevel = .moderate,
        rating: Double = 4.5,
        reviewCount: Int = 100,
        imageUrl: String = "https://example.com/mock-image.jpg",
        latitude: Double = 25.0,
        longitude: Double = 55.0,
        address: String = "Mock Address",
        phone: String? = "+1234567890",
        menuUrl: String? = "https://example.com/menu.pdf",
        labels: [RestaurantLabel] = [.casual, .goodForFamilies],
        isBookingRequired: Bool = false,
        isDifficultToBook: Bool = false,
        regionId: String = "mock-region-id"
    ) -> Restaurant {
        Restaurant(
            id: id,
            name: name,
            cuisine: cuisine,
            priceLevel: priceLevel,
            rating: rating,
            reviewCount: reviewCount,
            imageUrl: URL(string: imageUrl),
            location: RestaurantBasicLocation(
                latitude: latitude,
                longitude: longitude,
                address: address
            ),
            contact: RestaurantBasicContact(
                phone: phone,
                menuUrl: menuUrl.flatMap { URL(string: $0) }
            ),
            labels: labels,
            isBookingRequired: isBookingRequired,
            isDifficultToBook: isDifficultToBook,
            regionId: regionId
        )
    }

    /// Convenience method to maintain backward compatibility with your existing tests
    static func makeLegacy(
        id: String = UUID().uuidString,
        name: String = "Mock",
        rating: String = "4.5",
        imageUrl: String = ""
    ) -> Restaurant {
        return make(
            id: id,
            name: name,
            rating: Double(rating) ?? 4.5,
            imageUrl: imageUrl.isEmpty ? "https://example.com/default.jpg" : imageUrl
        )
    }

    /// Create multiple restaurants for testing lists
    static func makeMultiple(count: Int) -> [Restaurant] {
        return (1 ... count).map { index in
            make(
                id: "test-\(index)",
                name: "Test Restaurant \(index)",
                rating: 3.0 + Double(index) * 0.3,
                imageUrl: "https://example.com/image\(index).jpg"
            )
        }
    }

    /// Specific restaurant types for testing
    static func makeCasual() -> Restaurant {
        make(
            name: "Casual Dining",
            priceLevel: .budget,
            labels: [.casual, .goodForFamilies, .acceptsCreditCards]
        )
    }

    static func makeUpscale() -> Restaurant {
        make(
            name: "Fine Dining",
            priceLevel: .luxury,
            rating: 4.8,
            labels: [.upscale, .romantic, .goodForCouples]
        )
    }

    static func makeWithoutImage() -> Restaurant {
        make(imageUrl: "")
    }

    static func makeDetails(id: String = UUID().uuidString) -> RestaurantDetails {
        RestaurantDetails(
            id: id,
            name: "Mock Details Restaurant",
            cuisine: "Fusion",
            priceLevel: .expensive,
            rating: 4.8,
            reviewCount: 320,
            imageUrl: URL(string: "https://example.com/detail-image.jpg"),
            location: .init(
                latitude: 24.7136,
                longitude: 46.6753,
                address: .init(
                    line1: "King Fahd Road, Riyadh",
                    line2: "King Fahd Road, Riyadh",
                    city: "Riyadh",
                    province: "Riyadh",
                    postalCode: "12345"
                ),
                neighborhood: "King Fahd Road"
            ),
            contact: .init(
                phone: "+9661122334455",
                menuUrl: URL(string: "https://example.com/details-menu.pdf"),
                externalRatingsUrl: nil
            ),
            features: .init(
                hasAlcohol: false,
                hasOutdoorSeating: false,
                allowsSmoking: false,
                hasValet: false,
                acceptsBookings: false,
                isDifficultToBook: false
            ),
            operatingHours: OperatingHours(rawHours: ""),
            description: "This is a detailed description of the restaurant.",
            notice: nil,
            establishmentType: .cafe,
            labels: []
        )
    }
}
