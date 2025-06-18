//
//  TestRestaurantDTOFactory.swift
//  EatAppAssessment
//
//  Created by Ali Bamohammad on 18/06/2025.
//
@testable import EatAppAssessment
import Foundation

enum TestRestaurantDTOFactory {
    static func make(
        id: String = UUID().uuidString,
        name: String = "Mock Restaurant",
        priceLevel: Int = 2,
        phone: String? = "+1234567890",
        menuUrl: String? = "https://example.com/menu.pdf",
        requireBookingPreferenceEnabled: Bool = false,
        difficult: Bool = false,
        cuisine: String = "Test Cuisine",
        imageUrl: String = "https://example.com/mock-image.jpg",
        latitude: Double = 25.0,
        longitude: Double = 55.0,
        addressLine1: String = "Mock Address",
        ratingsAverage: String = "4.5",
        ratingsCount: Int = 100,
        labels: [String] = ["Casual", "Good for Families"],
        regionId: String = "mock-region-id"
    ) -> RestaurantListItemDTO {
        
        return RestaurantListItemDTO(
            id: id,
            type: "restaurant",
            attributes: RestaurantListAttributesDTO(
                name: name,
                priceLevel: priceLevel,
                phone: phone,
                menuUrl: menuUrl,
                requireBookingPreferenceEnabled: requireBookingPreferenceEnabled,
                difficult: difficult,
                cuisine: cuisine,
                imageUrl: imageUrl,
                latitude: latitude,
                longitude: longitude,
                addressLine1: addressLine1,
                ratingsAverage: ratingsAverage,
                ratingsCount: ratingsCount,
                labels: labels
            ),
            relationships: RestaurantListRelationshipsDTO(
                region: RelationshipDataDTO(
                    data: RelationshipItemDTO(
                        id: regionId,
                        type: "region"
                    )
                )
            )
        )
    }
    
    // Convenience method to maintain backward compatibility with your existing tests
    static func makeLegacy(
        id: String = UUID().uuidString,
        name: String = "Mock",
        rating: String = "4.5",
        imageUrl: String = ""
    ) -> RestaurantListItemDTO {
        return make(
            id: id,
            name: name,
            imageUrl: imageUrl.isEmpty ? "https://example.com/default.jpg" : imageUrl,
            ratingsAverage: rating
        )
    }
    
    // Create multiple DTOs for testing
    static func makeMultiple(count: Int) -> [RestaurantListItemDTO] {
        return (1...count).map { index in
            make(
                id: "test-dto-\(index)",
                name: "Test Restaurant DTO \(index)",
                imageUrl: "https://example.com/image\(index).jpg",
                ratingsAverage: String(format: "%.1f", 3.0 + Double(index) * 0.3)
            )
        }
    }
    
    // Create DTO with minimal data
    static func makeMinimal() -> RestaurantListItemDTO {
        make(
            phone: nil,
            menuUrl: nil,
            labels: []
        )
    }
    
    // Create DTO with all optional fields populated
    static func makeComplete() -> RestaurantListItemDTO {
        make(
            phone: "+97144262626",
            menuUrl: "https://example.com/complete-menu.pdf",
            requireBookingPreferenceEnabled: true,
            difficult: true,
            labels: [
                "Dressy",
                "Good for Couples",
                "Romantic",
                "Upscale",
                "Good for Dinner",
                "Accepts Credit Cards"
            ]
        )
    }
    
    // Specific restaurant types for testing different scenarios
    static func makeAsianRestaurant() -> RestaurantListItemDTO {
        make(
            name: "Miss Tess",
            cuisine: "Asian",
            imageUrl: "https://ucarecdn.com/a0f30bef-d067-4278-a256-f14448040504/",
            latitude: 25.192265,
            longitude: 55.267255,
            addressLine1: "Business Bay",
            ratingsAverage: "4.5",
            ratingsCount: 195,
            labels: [
                "Casual",
                "Good for Groups",
                "Good for Families",
                "Good for Couples",
                "Fun",
                "Great Service"
            ]
        )
    }
    
    static func makeJapaneseRestaurant() -> RestaurantListItemDTO {
        make(
            name: "Nobu",
            priceLevel: 3,
            cuisine: "Japanese",
            imageUrl: "https://ucarecdn.com/a117956c-356d-4cd1-8aa2-61882a4b5979/",
            latitude: 25.132155,
            longitude: 55.117581,
            addressLine1: "Ground Level, The Avenues, Atlantis",
            ratingsAverage: "4.0",
            ratingsCount: 2126,
            labels: [
                "Dressy",
                "Good for Brunch",
                "Good for Dinner"
            ]
        )
    }
}

// MARK: - Test Response Factories

enum TestRestaurantListResponseFactory {
    static func make(
        restaurants: [RestaurantListItemDTO] = [TestRestaurantDTOFactory.make()],
        currentPage: Int = 1,
        totalPages: Int = 1,
        totalCount: Int = 1,
        limit: Int = 10
    ) -> RestaurantListResponseDTO {
        RestaurantListResponseDTO(
            data: restaurants,
            meta: PaginationMetaDTO(
                limit: limit,
                totalPages: totalPages,
                totalCount: totalCount,
                currentPage: currentPage
            )
        )
    }
    
    static func makeFirstPage(restaurants: [RestaurantListItemDTO], totalPages: Int = 3) -> RestaurantListResponseDTO {
        make(
            restaurants: restaurants,
            currentPage: 1,
            totalPages: totalPages,
            totalCount: totalPages * 10
        )
    }
    
    static func makeLastPage(restaurants: [RestaurantListItemDTO], totalPages: Int = 3) -> RestaurantListResponseDTO {
        make(
            restaurants: restaurants,
            currentPage: totalPages,
            totalPages: totalPages,
            totalCount: totalPages * 10
        )
    }
    
    static func makeEmpty() -> RestaurantListResponseDTO {
        make(
            restaurants: [],
            totalCount: 0
        )
    }
}

extension TestRestaurantDTOFactory {
    // Special handling for tests that expect specific rating values based on image URLs
    static func makeWithImageRatingLogic(
        id: String = UUID().uuidString,
        name: String = "Mock",
        imageUrl: String = ""
    ) -> RestaurantListItemDTO {
        // Maintain the logic from your original tests
        let rating: String
        if imageUrl.contains("img2.jpg") {
            rating = "4.6"
        } else if imageUrl.contains("2.jpg") {
            rating = "4.6"
        } else {
            rating = "4.2"
        }
        
        return make(
            id: id,
            name: name,
            imageUrl: imageUrl.isEmpty ? "https://example.com/default.jpg" : imageUrl,
            ratingsAverage: rating
        )
    }
}
