//
//  RestaurantDetailsAPI.swift
//  EatAppAssessment
//
//  Created by Ali Bamohammad on 18/06/2025.
//

protocol RestaurantDetailsAPI {
    func fetchRestaurant(id: String) async throws -> RestaurantResponseDTO
}

final class DefaultRestaurantDetailsAPI: RestaurantDetailsAPI {
    private let client: APIClient

    init(client: APIClient = DefaultAPIClient()) {
        self.client = client
    }

    func fetchRestaurant(id: String) async throws -> RestaurantResponseDTO {
        let request = APIRequest(
            path: "/consumer/v2/restaurants/\(id)",
            method: .GET,
            headers: ["Content-Type": "application/json"],
        )
        return try await client.request(request)
    }
}
