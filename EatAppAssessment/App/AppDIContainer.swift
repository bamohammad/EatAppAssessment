//
//  AppDIContainer.swift
//  EatAppAssessment
//
//  Created by Ali Bamohammad on 18/06/2025.
//

import CoreData
import Foundation
import SwiftData

@MainActor
final class DIContainer {
    static let shared = DIContainer()
    private init() {}

    private var factories: [ObjectIdentifier: () -> Any] = [:]

    func register<Service>(
        _ type: Service.Type = Service.self,
        factory: @escaping () -> Service
    ) {
        factories[ObjectIdentifier(type)] = factory
    }

    func resolve<Service>(_ type: Service.Type = Service.self) -> Service {
        guard let service = factories[ObjectIdentifier(type)]?() as? Service else {
            fatalError("No registration for \(type)")
        }
        return service
    }

    func reset() {
        factories.removeAll()
    }
}

extension DIContainer {
    func registerNetworking(baseURL: URL = URL(string: "https://api.eat-sandbox.co")!) {
        register(APIClient.self) {
            DefaultAPIClient(baseURL: baseURL)
        }
    }
}

extension DIContainer {
    func registerAPIs() {
        register(APIClient.self) {
            DefaultAPIClient()
        }

        register(RestaurantAPI.self) { [unowned self] in
            DefaultRestaurantAPI(client: self.resolve(APIClient.self))
        }

        register(RestaurantDetailsAPI.self) { [unowned self] in
            DefaultRestaurantDetailsAPI(client: self.resolve(APIClient.self))
        }
    }

    func registerRepositories() {
        register(RestaurantRepository.self) { [unowned self] in
            DefaultRestaurantRepository(api: resolve())
        }

        register(RestaurantDetailsRepository.self) { [unowned self] in
            DefaultRestaurantDetailsRepository(api: resolve())
        }
    }

    func registerUseCases() {
        register(GetRestaurantsUseCase.self) { [unowned self] in
            DefaultGetRestaurantsUseCase(repository: resolve())
        }

        register(GetRestaurantDetailsUseCase.self) { [unowned self] in
            DefaultGetRestaurantDetailsUseCase(repository: resolve())
        }
    }
}
