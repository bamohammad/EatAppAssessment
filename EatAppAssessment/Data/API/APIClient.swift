//
//  APIClient.swift
//  EatAppAssessment
//
//  Created by Ali Bamohammad on 18/06/2025.
//

import Foundation

protocol APIClient {
    func request<T: Decodable>(_ request: APIRequest) async throws -> T
}

final class DefaultAPIClient: APIClient {
    private let baseURL: URL
    private let session: URLSession

    init(baseURL: URL = URL(string: "https://api.eat-sandbox.co")!) {
        self.baseURL = baseURL
        session = URLSession.shared
    }

    func request<T: Decodable>(_ request: APIRequest) async throws -> T {
        var urlComponents = URLComponents(url: baseURL.appendingPathComponent(request.path), resolvingAgainstBaseURL: false)
        urlComponents?.queryItems = request.queryItems

        guard let url = urlComponents?.url else {
            throw URLError(.badURL)
        }

        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = request.method.rawValue
        urlRequest.allHTTPHeaderFields = request.headers
        urlRequest.httpBody = request.body

        let (data, response) = try await session.data(for: urlRequest)

        guard let httpResponse = response as? HTTPURLResponse, 200 ..< 300 ~= httpResponse.statusCode else {
            throw URLError(.badServerResponse)
        }

        return try JSONDecoder().decode(T.self, from: data)
    }
}
