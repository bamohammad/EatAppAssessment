//
//  AppTheme.swift
//  EatAppAssessment
//
//  Created by Ali Bamohammad on 18/06/2025.
//


import SwiftUI

struct AppTheme {
    let colors: ThemeColors
    let colorScheme: ColorScheme

    static let light = AppTheme(
        colors: ThemeColors.light,
        colorScheme: .light
    )

    static let dark = AppTheme(
        colors: ThemeColors.dark,
        colorScheme: .dark
    )
}


enum AppThemeMode: Equatable {
    case light
    case dark
}
