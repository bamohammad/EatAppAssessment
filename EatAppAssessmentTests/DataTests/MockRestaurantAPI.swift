//
//  MockRestaurantAPI.swift
//  EatAppAssessment
//
//  Created by Ali Bamohammad on 18/06/2025.
//
@testable import EatAppAssessment

final class MockRestaurantAPI: RestaurantAPI {
    
    // MARK: - Config
    var result: Result<RestaurantListResponseDTO, Error> = .success(
        RestaurantListResponseDTO(
            data: [],
            meta: PaginationMetaDTO(
                limit: 10,
                totalPages: 1,
                totalCount: 0,
                currentPage: 1
            )
        )
    )
    var artificialDelay: UInt64 = 0 

    // MARK: - Spy
    private(set) var recordedRequests: [(page: Int, limit: Int)] = []

    func fetchRestaurants(regionId: String, page: Int, limit: Int) async throws -> RestaurantListResponseDTO {
        recordedRequests.append((page, limit))
        if artificialDelay > 0 {
            try await Task.sleep(nanoseconds: artificialDelay)
        }
        return try result.get()
    }

    func reset() {
        recordedRequests = []
        artificialDelay = 0
        result = .success(
            RestaurantListResponseDTO(
                data: [],
                meta: PaginationMetaDTO(
                    limit: 10,
                    totalPages: 1,
                    totalCount: 0,
                    currentPage: 1
                )
            )
        )
    }
}
