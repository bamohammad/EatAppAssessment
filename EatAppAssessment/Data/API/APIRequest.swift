//
//  APIRequest.swift
//  EatAppAssessment
//
//  Created by Ali Bamohammad on 18/06/2025.
//


import Foundation

struct APIRequest {
    var path: String
    var method: HTTPMethod
    var headers: [String: String] = [:]
    var queryItems: [URLQueryItem] = []
    var body: Data? = nil
}

enum HTTPMethod: String {
    case GET, POST, PATCH, PUT, DELETE
}
