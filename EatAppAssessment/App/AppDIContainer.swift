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
final class AppDIContainer:ObservableObject {
    // MARK: - APIs

    private lazy var restaurantAPI = DefaultRestaurantAPI()
    private lazy var restaurantDetailsAPI = DefaultRestaurantDetailsAPI()

    // MARK: - Repositories

    func makeRestaurantDetailsRepository() -> RestaurantRepository {
        DefaultRestaurantRepository(api: restaurantAPI)
    }

    func makeRestaurantDetailsRepository() -> RestaurantDetailsRepository {
        DefaultRestaurantDetailsRepository(api: restaurantDetailsAPI)
    }

    // MARK: - Use-cases
    
    func makeGetRestaurantsUseCase() -> GetRestaurantsUseCase {
        DefaultGetRestaurantsUseCase(repository: makeRestaurantDetailsRepository())
    }

    func makeGetRestaurantDetailsUseCase() -> GetRestaurantDetailsUseCase {
        DefaultGetRestaurantDetailsUseCase(repository: makeRestaurantDetailsRepository())
    }
    
}
