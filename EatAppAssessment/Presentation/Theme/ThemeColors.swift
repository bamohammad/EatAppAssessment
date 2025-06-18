//
//  ThemeColors.swift
//  EatAppAssessment
//
//  Created by Ali Bamohammad on 18/06/2025.
//

import SwiftUI

struct ThemeColors {
    // Core colors
    let primary: Color
    let background: Color
    let text: Color
    let secondaryText: Color
    let error: Color
    
    // UI specific colors
    let backgroundLight: Color
    let warmOrange: Color
    
    // Gradients for components
    let gradientTealSeafoam: LinearGradient
    let gradientMintGold: LinearGradient

    static let light = ThemeColors(
        primary: Color(hex:"#34353A"),
        background: Color.white,
        text: Color.black,
        secondaryText: Color.gray,
        error: Color.red,
        
        backgroundLight: Color(hex: "#F3F3F3"),
        warmOrange: Color(hex: "#FFBC53"),
        
        gradientTealSeafoam: LinearGradient(
            colors: [
                Color(red: 37/255, green: 172/255, blue: 168/255, opacity: 0.1),
                Color(red: 0/255, green: 172/255, blue: 161/255, opacity: 0.1)
            ],
            startPoint: .leading,
            endPoint: .trailing
        ),
        gradientMintGold: LinearGradient(
            colors: [
                Color(red: 157/255, green: 172/255, blue: 37/255, opacity: 0.1),
                Color(red: 172/255, green: 169/255, blue: 0/255, opacity: 0.1)
            ],
            startPoint: .leading,
            endPoint: .trailing
        )
    )

    static let dark = ThemeColors(
        primary: Color("#FFFFFF"),
        background: Color.black,
        text: Color.white,
        secondaryText: Color.gray,
        error: Color.red,
        
        backgroundLight: Color(hex: "#2C2C2E"),
        warmOrange: Color(hex: "#FFBC53"),
        
        gradientTealSeafoam: LinearGradient(
            colors: [
                Color(red: 37/255, green: 172/255, blue: 168/255, opacity: 0.1),
                Color(red: 0/255, green: 172/255, blue: 161/255, opacity: 0.1)
            ],
            startPoint: .leading,
            endPoint: .trailing
        ),
        gradientMintGold: LinearGradient(
            colors: [
                Color(red: 157/255, green: 172/255, blue: 37/255, opacity: 0.1),
                Color(red: 172/255, green: 169/255, blue: 0/255, opacity: 0.1)
            ],
            startPoint: .leading,
            endPoint: .trailing
        )
    )
}

// MARK: - Color Extension for Hex Support

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}
