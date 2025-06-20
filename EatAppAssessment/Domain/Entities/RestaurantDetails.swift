//
//  RestaurantDetails.swift
//  EatAppAssessment
//
//  Created by Ali Bamohammad on 18/06/2025.
//
import Foundation

struct RestaurantDetails: Identifiable, Equatable {
    let id: String
    let name: String
    let cuisine: String
    let priceLevel: PriceLevel
    let rating: Double
    let reviewCount: Int
    let imageUrl: URL?
    let location: RestaurantLocation
    let description: String
    let notice: String?
    let labels: [RestaurantLabel]
}

struct RestaurantLocation: Equatable {
    let latitude: Double
    let longitude: Double
    let address: Address
    let neighborhood: String
}

struct Address: Equatable {
    let line1: String
    let line2: String?
    let city: String
    let province: String
    let postalCode: String

    var fullAddress: String {
        var components = [line1]
        if let line2 = line2, !line2.isEmpty {
            components.append(line2)
        }
        components.append("\(city), \(province) \(postalCode)")
        return components.joined(separator: ", ")
    }
}

// MARK: - Enums

enum PriceLevel: Int, CaseIterable {
    case budget = 1
    case moderate = 2
    case expensive = 3
    case luxury = 4

    var symbol: String {
        String(repeating: "$", count: rawValue)
    }

    var description: String {
        switch self {
        case .budget: return "Budget-friendly"
        case .moderate: return "Moderate"
        case .expensive: return "Expensive"
        case .luxury: return "Luxury"
        }
    }
}

enum RestaurantLabel: String, CaseIterable {
    case casual = "Casual"
    case dressy = "Dressy"
    case smartCasual = "Smart Casual"
    case goodForGroups = "Good for Groups"
    case goodForFamilies = "Good for Families"
    case goodForCouples = "Good for Couples"
    case romantic = "Romantic"
    case upscale = "Upscale"
    case fun = "Fun"
    case greatService = "Great Service"
    case specialOccasion = "Special Occasion"
    case veganFriendly = "Vegan Friendly"
    case goodForBirthdays = "Good for Birthdays"
    case vegetarian = "Vegetarian"
    case scenicView = "Scenic View"
    case goodForBreakfast = "Good for Breakfast"
    case goodForBrunch = "Good for Brunch"
    case goodForLunch = "Good for Lunch"
    case goodForDinner = "Good for Dinner"
    case acceptsCreditCards = "Accepts Credit Cards"
    case acceptsCash = "Accepts Cash"

    var displayName: String {
        rawValue
    }

    var systemImage: String {
        switch self {
        case .casual: return "person.casual"
        case .dressy: return "tshirt"
        case .smartCasual: return "person.crop.rectangle"
        case .goodForGroups: return "person.3"
        case .goodForFamilies: return "figure.and.child.holdinghands"
        case .goodForCouples: return "heart"
        case .romantic: return "heart.circle"
        case .upscale: return "crown"
        case .fun: return "party.popper"
        case .greatService: return "star.circle"
        case .specialOccasion: return "gift"
        case .veganFriendly: return "leaf"
        case .goodForBirthdays: return "birthday.cake"
        case .vegetarian: return "carrot"
        case .scenicView: return "mountain.2"
        case .goodForBreakfast: return "sunrise"
        case .goodForBrunch: return "sun.max"
        case .goodForLunch: return "sun.max.fill"
        case .goodForDinner: return "moon"
        case .acceptsCreditCards: return "creditcard"
        case .acceptsCash: return "banknote"
        }
    }

    var category: LabelCategory {
        switch self {
        case .casual, .dressy, .smartCasual, .upscale:
            return .dressCode
        case .goodForGroups, .goodForFamilies, .goodForCouples, .romantic:
            return .audience
        case .goodForBreakfast, .goodForBrunch, .goodForLunch, .goodForDinner:
            return .mealTime
        case .veganFriendly, .vegetarian:
            return .dietary
        case .acceptsCreditCards, .acceptsCash:
            return .payment
        default:
            return .atmosphere
        }
    }
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
