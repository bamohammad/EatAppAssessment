//
//  ThemeManager.swift
//  EatAppAssessment
//
//  Created by Ali Bamohammad on 18/06/2025.
//


import Combine
import SwiftUI

final class ThemeManager: ObservableObject {
    @Published private(set) var currentThemeMode: AppThemeMode = .light

    var currentTheme: AppTheme {
        switch currentThemeMode {
        case .light: return .light
        case .dark: return .dark
        }
    }

    var isDarkMode: Bool {
        currentThemeMode == .dark
    }

    func toggleTheme() {
        currentThemeMode = (currentThemeMode == .light) ? .dark : .light
    }

    func setLight() {
        currentThemeMode = .light
    }

    func setDark() {
        currentThemeMode = .dark
    }
}
