//
//  RestaurantDetailsDTO.swift
//  EatAppAssessment
//
//  Created by Ali Bamohammad on 18/06/2025.
//

// MARK: - Root

struct RestaurantResponseDTO: Codable {
    let data: RestaurantDataDTO?
}

struct RestaurantDataDTO: Codable {
    let id: String?
    let type: String?
    let attributes: RestaurantAttributesDTO?
    let relationships: RestaurantRelationshipsDTO?
}

struct RestaurantAttributesDTO: Codable {
    let name: String?
    let priceLevel: Int?
    let phone: String?
    let menuUrl: String?
    let requireBookingPreferenceEnabled: Bool
    let difficult: Bool?
    let cuisine: String?
    let imageUrl: String?
    let latitude: Double?
    let longitude: Double?
    let addressLine1: String?
    let ratingsAverage: String?
    let ratingsCount: Int?
    let labels: [String]?
    let alcohol: Bool?
    let deal: String?
    let description: String?
    let establishmentType: String?
    let externalRatingsUrl: String?
    let imageUrls: [String]?
    let neighborhoodName: String?
    let notice: String?
    let operatingHours: String?
    let outdoorSeating: Bool?
    let postalCode: String?
    let province: String?
    let relationshipType: String?
    let reservationNoticeDuration: Int?
    let smoking: Bool?
    let valet: Bool?
    let slug: String?
    let key: String?
    let addressLine2: String?
    let city: String?
    let customConfirmationComments: String?
    let termsAndConditions: String?
    let ratingsImg: String?
    
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
        case alcohol
        case deal
        case description
        case establishmentType = "establishment_type"
        case externalRatingsUrl = "external_ratings_url"
        case imageUrls = "image_urls"
        case neighborhoodName = "neighborhood_name"
        case notice
        case operatingHours = "operating_hours"
        case outdoorSeating = "outdoor_seating"
        case postalCode = "postal_code"
        case province
        case relationshipType = "relationship_type"
        case reservationNoticeDuration = "reservation_notice_duration"
        case smoking
        case valet
        case slug
        case key
        case addressLine2 = "address_line_2"
        case city
        case customConfirmationComments = "custom_confirmation_comments"
        case termsAndConditions = "terms_and_conditions"
        case ratingsImg = "ratings_img"
    }
}

struct RestaurantRelationshipsDTO: Codable {
    let region: RelationshipDataDTO?
    let promotionalGroups: RelationshipArrayDTO?
    let rating: RelationshipDataDTO?
    let experiences: RelationshipArrayDTO?
    let onlineSeatingShifts: RelationshipArrayDTO?
    
    enum CodingKeys: String, CodingKey {
        case region
        case promotionalGroups = "promotional_groups"
        case rating
        case experiences
        case onlineSeatingShifts = "online_seating_shifts"
    }
}

struct RelationshipDataDTO: Codable {
    let data: RelationshipItemDTO?
}

struct RelationshipArrayDTO: Codable {
    let data: [RelationshipItemDTO]?
}

struct RelationshipItemDTO: Codable {
    let id: String?
    let type: String?
}

struct ReviewDTO: Codable {
    let publishedDate: String?
    let rating: Int?
    let ratingImageUrl: String?
    let url: String?
    let text: String?
    let user: UserDTO?
    let title: String?
    
    enum CodingKeys: String, CodingKey {
        case publishedDate = "published_date"
        case rating
        case ratingImageUrl = "rating_image_url"
        case url
        case text
        case user
        case title
    }
}

struct UserDTO: Codable {
    let username: String?
    let userLocation: UserLocationDTO?
    
    enum CodingKeys: String, CodingKey {
        case username
        case userLocation = "user_location"
    }
}

struct UserLocationDTO: Codable {
    let name: String?
    let id: String?
}
