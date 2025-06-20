//
//  EatAppAssessmentApp.swift
//  EatAppAssessment
//
//  Created by Ali Bamohammad on 18/06/2025.
//

import SwiftUI

@main
struct EatAppAssessmentApp: App {
    
    // MARK: - State & Dependencies
    
    @StateObject private var themeManager = ThemeManager()
    private let appNavigation = AppNavigation()
    
    // MARK: - Init
    
    init() {
        setupDependencies()
    }

    // MARK: - Body
    
    var body: some Scene {
        WindowGroup {
            RestaurantListView(viewModel: makeRestaurantListViewModel())
                .withEnvironment(themeManager: themeManager, appNavigation: appNavigation)
        }
    }

    // MARK: - Factory
    
    private func makeRestaurantListViewModel() -> RestaurantListViewModel {
        RestaurantListViewModel(useCase: DIContainer.shared.resolve())
    }

    // MARK: - DI Setup
    
    private func setupDependencies() {
        DIContainer.shared.registerAPIs()
        DIContainer.shared.registerRepositories()
        DIContainer.shared.registerUseCases()
    }
}

// MARK: - View Extension for Global Environment

private extension View {
    func withEnvironment(
        themeManager: ThemeManager,
        appNavigation: AppNavigation
    ) -> some View {
        self
            .environment(\.theme, themeManager.currentTheme)
            .environmentObject(themeManager)
            .environmentObject(appNavigation)
            .preferredColorScheme(themeManager.currentTheme.colorScheme)
    }
}

// MARK: - ThemeManager Helper

extension ThemeManager {
    var currentColorScheme: ColorScheme {
        currentTheme.colorScheme
    }
}
