//
//  AppNavigation.swift
//  EatAppAssessment
//
//  Created by Ali Bamohammad on 19/06/2025.
//
import SwiftUI

final class AppNavigation: ObservableObject {
    @Published var path = NavigationPath()

    func navigate(route: Route) {
        DispatchQueue.main.async { [weak self] in
            self?.path.append(route)
        }
    }

    func pop() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self,
                  !self.path.isEmpty else {
                return
            }
            self.path.removeLast()
        }
    }

    func popToRoot() {
        DispatchQueue.main.async { [weak self] in
            self?.path = NavigationPath()
        }
    }

    enum Route: Hashable {
        case restaurantDetails(restaurant: Restaurant)

        func hash(into hasher: inout Hasher) {
            switch self {
            case let .restaurantDetails(restaurant):
                hasher.combine(restaurant.id)
            }
        }
    }
}
