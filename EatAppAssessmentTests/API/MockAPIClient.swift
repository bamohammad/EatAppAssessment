//
//  MockAPIClient.swift
//  EatAppAssessment
//
//  Created by Ali Bamohammad on 18/06/2025.
//

@testable import EatAppAssessment
import XCTest

final class MockAPIClient: APIClient {
    enum MockResult {
        case success(Data)
        case failure(Error)
    }

    var result: MockResult = .success(Data())

    func request<T: Decodable>(_: APIRequest) async throws -> T {
        switch result {
        case let .success(data):
            return try JSONDecoder().decode(T.self, from: data)
        case let .failure(error):
            throw error
        }
    }
}
