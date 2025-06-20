//
//  RestaurantAPI.swift
//  EatAppAssessment
//
//  Created by Ali Bamohammad on 18/06/2025.
//


import Foundation

protocol RestaurantAPI {
    func fetchRestaurants(regionId: String, page: Int, limit: Int) async throws -> RestaurantListResponseDTO
}

final class DefaultRestaurantAPI: RestaurantAPI {
    private let client: APIClient

    init(client: APIClient) {
        self.client = client
    }

    func fetchRestaurants(regionId: String, page: Int, limit: Int) async throws -> RestaurantListResponseDTO {
        let request = APIRequest(
            path: "/consumer/v2/restaurants",
            method: .GET,
            headers: ["Content-Type": "application/json"],
            queryItems: [
                URLQueryItem(name: "region_id", value: regionId),
                URLQueryItem(name: "limit", value: "\(limit)"),
                URLQueryItem(name: "page", value: "\(page)")
            ]
        )
        return try await client.request(request)
    }
}
