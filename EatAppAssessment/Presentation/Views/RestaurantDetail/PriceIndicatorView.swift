//
//  PriceIndicatorView.swift
//  EatAppAssessment
//
//  Created by Ali Bamohammad on 19/06/2025.
//
import SwiftUI

struct PriceIndicatorView: View {
    enum Style {
        case primary
        case secondary
    }

    let price: String
    let style: Style
    @Environment(\.theme) private var theme

    private enum Constants {
        static let maxDollarSigns = 3
        static let horizontalPadding: CGFloat = 18
        static let verticalPadding: CGFloat = 8
    }

    private var backgroundGradient: LinearGradient? {
        switch style {
        case .primary:
            return theme.colors.gradientTealSeafoam
        case .secondary:
            return nil
        }
    }

    var body: some View {
        HStack(spacing: 0) {
            Image("dollar")
                .frame(height: style == .secondary ? 12 : 18)

            HStack(spacing: 0) {
                Text(String(repeating: "$", count: min(Constants.maxDollarSigns, max(0, price.count))))
                    .foregroundColor(theme.colors.text)
                    .font(.caption)

                Text(String(repeating: "$", count: max(0, Constants.maxDollarSigns - price.count)))
                    .foregroundColor(theme.colors.secondaryText)
                    .font(.caption)
            }
        }
        .font(.caption)
        .padding(.horizontal, style == .secondary ? 0 : Constants.horizontalPadding)
        .padding(.vertical, Constants.verticalPadding)
        .background(backgroundGradient)
        .clipShape(Capsule())
    }
}
