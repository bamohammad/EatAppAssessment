//
//  MockRestaurantRepository.swift
//  EatAppAssessment
//
//  Created by Ali Bamohammad on 18/06/2025.
//
@testable import EatAppAssessment
import Foundation

final class MockRestaurantRepository: RestaurantRepository {
    
    // MARK: - Config
    var valuesToEmit: [Restaurant] = []
    var errorPages: Set<Int> = []
    var errorToThrow: Error?
    var artificialDelay: UInt64 = 0
    var customPaginationInfo: PaginationInfo?

    // MARK: - Spy
    private(set) var recordedRequests: [(page: Int, limit: Int)] = []

    func fetchRestaurants(regionId: String, page: Int, limit: Int) async throws -> RestaurantList {
        recordedRequests.append((page, limit))
        if artificialDelay > 0 {
            try await Task.sleep(nanoseconds: artificialDelay)
        }

        if let error = errorToThrow {
            throw error
        }
        
        if errorPages.contains(page) {
            throw NSError(
                domain: "MockError",
                code: page,
                userInfo: [NSLocalizedDescriptionKey: "Failed to load page \(page)"]
            )
        }

        let start = (page - 1) * limit
        let end = min(start + limit, valuesToEmit.count)
        let items = (start < end) ? Array(valuesToEmit[start..<end]) : []

        let totalPages = valuesToEmit.isEmpty ? 0 : Int(ceil(Double(valuesToEmit.count) / Double(limit)))
        
        let paginationInfo = customPaginationInfo ?? PaginationInfo(
            limit: limit,
            totalPages: totalPages,
            totalCount: valuesToEmit.count,
            currentPage: page
        )
        
        return RestaurantList(
            restaurants: items,
            pagination: paginationInfo
        )
    }

    func reset() {
        valuesToEmit = []
        errorPages = []
        errorToThrow = nil
        recordedRequests = []
        artificialDelay = 0
        customPaginationInfo = nil
    }
    
    // MARK: - Test Helpers
    
    func setCustomPagination(
        limit: Int,
        totalPages: Int,
        totalCount: Int,
        currentPage: Int
    ) {
        customPaginationInfo = PaginationInfo(
            limit: limit,
            totalPages: totalPages,
            totalCount: totalCount,
            currentPage: currentPage
        )
    }
    
    
    func simulateEmptyResponse() {
        valuesToEmit = []
        customPaginationInfo = PaginationInfo(
            limit: 10,
            totalPages: 0,
            totalCount: 0,
            currentPage: 1
        )
    }
    
    func simulatePagedResponse(totalRestaurants: Int, pageSize: Int = 10) {
        valuesToEmit = (1...totalRestaurants).map { index in
            TestRestaurantFactory.make(
                id: "\(index)",
                name: "Restaurant \(index)",
                rating:3.0 + Double(index % 20) * 0.1
            )
        }
    }
}

