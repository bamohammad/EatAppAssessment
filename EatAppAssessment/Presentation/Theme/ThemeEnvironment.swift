//
//  ThemeEnvironment.swift
//  EatAppAssessment
//
//  Created by Ali Bamohammad on 18/06/2025.
//

import SwiftUI

private struct ThemeKey: EnvironmentKey {
    static let defaultValue: AppTheme = .dark
}

extension EnvironmentValues {
    var theme: AppTheme {
        get { self[ThemeKey.self] }
        set { self[ThemeKey.self] = newValue }
    }
}
