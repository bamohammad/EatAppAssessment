//
//  EatAppAssessmentApp.swift
//  EatAppAssessment
//
//  Created by Ali Bamohammad on 18/06/2025.
//

import SwiftUI

// MARK: - EatAppAssessmentApp

@main
struct EatAppAssessmentApp: App {
    
    // MARK: - Properties
    
    @StateObject private var themeManager = ThemeManager()
    private let appNavigation = AppNavigation()
    private let appDIContainer = AppDIContainer()
    
    // MARK: - Scene
    
    var body: some Scene {
        WindowGroup {
            rootView
                .setupEnvironment(
                    themeManager: themeManager,
                    appNavigation: appNavigation,
                    appDIContainer: appDIContainer
                )
        }
    }
}

// MARK: - Private Extensions

private extension EatAppAssessmentApp {
    var rootView: some View {
        RestaurantListView(
            viewModel: createRestaurantListViewModel()
        )
    }
    
    func createRestaurantListViewModel() -> RestaurantListViewModel {
        RestaurantListViewModel(
            useCase: appDIContainer.makeGetRestaurantsUseCase()
        )
    }
}

// MARK: - View Extensions

private extension View {
    func setupEnvironment(
        themeManager: ThemeManager,
        appNavigation: AppNavigation,
        appDIContainer: AppDIContainer
    ) -> some View {
        self
            .environment(\.theme, themeManager.currentTheme)
            .environmentObject(themeManager)
            .environmentObject(appDIContainer)
            .environmentObject(appNavigation)
            .preferredColorScheme(themeManager.currentTheme.colorScheme)
    }
}

// MARK: - Theme Manager Extension

extension ThemeManager {
    /// Convenience computed property for current color scheme
    var currentColorScheme: ColorScheme {
        currentTheme.colorScheme
    }
}

