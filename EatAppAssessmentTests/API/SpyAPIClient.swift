//
//  SpyAPIClient.swift
//  EatAppAssessment
//
//  Created by Ali Bamohammad on 18/06/2025.
//
@testable import EatAppAssessment
import XCTest

final class SpyAPIClient: APIClient {
    var capturedRequest: APIRequest?
    var result: Result<Data, Error> = .success(Data())

    func request<T: Decodable>(_ request: APIRequest) async throws -> T {
        capturedRequest = request
        
        switch result {
        case let .success(data):
            return try JSONDecoder().decode(T.self, from: data)
        case let .failure(error):
            throw error
        }
    }
}
