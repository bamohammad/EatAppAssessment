//
//  MockVenuesData.swift
//  EatAppAssessment
//
//  Created by Ali Bamohammad on 19/06/2025.
//
import Foundation

enum MockVenuesData {
    static let relatedVenues: [VenueCardData] = [VenueCardData(
        name: "A Casa do Porco",
        rating: "4.8",
        cuisine: "Italian Fine Dining",
        price: "$$",
        image: URL(string: "https://ucarecdn.com/13880346-44bd-4a6b-a1e7-df3ba66af611/")
    ),
    VenueCardData(
        name: "Septime",
        rating: "4.8",
        cuisine: "Italian Fine Dining",
        price: "$$$",
        image: URL(string: "https://ucarecdn.com/6ea3c1a5-f6da-4f84-8daf-0b51ee113858/")
    ),
    VenueCardData(
        name: "Odette",
        rating: "4.9",
        cuisine: "Italian Fine Dining",
        price: "$$$",
        image: URL(string: "https://ucarecdn.com/13880346-44bd-4a6b-a1e7-df3ba66af611/")
    )]

    static let nearbyVenues: [VenueCardData] = [VenueCardData(
        name: "Disfrutar",
        rating: "4.8",
        cuisine: "Italian Fine Dining",
        price: "$$$",
        image: URL(string: "https://ucarecdn.com/13880346-44bd-4a6b-a1e7-df3ba66af611/")
    ),
    VenueCardData(
        name: "Central",
        rating: "4.8",
        cuisine: "International",
        price: "$$$",
        image: URL(string: "https://ucarecdn.com/ce9354d8-fa87-4c09-b850-955b4244dfc4/")
    ),
    VenueCardData(
        name: "Odette",
        rating: "4.9",
        cuisine: "Asian",
        price: "$$$",
        image: URL(string: "https://ucarecdn.com/13880346-44bd-4a6b-a1e7-df3ba66af611/")
    )]
}

struct VenueCardData {
    let name: String
    let rating: String
    let cuisine: String
    let price: String
    let image: URL?
}
