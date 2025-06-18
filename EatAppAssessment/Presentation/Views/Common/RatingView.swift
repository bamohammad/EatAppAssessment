//
//  RatingView.swift
//  EatAppAssessment
//
//  Created by Ali Bamohammad on 19/06/2025.
//
import SwiftUI

struct RatingView: View {
    @Environment(\.theme) private var theme
    let rating: String
    var body: some View {
        HStack(alignment: .center, spacing: 4) {
            Image(systemName: "star.fill")
                .foregroundStyle(theme.colors.warmOrange)
                .font(.callout)

            Text(rating)
                .font(.caption.bold())
                .foregroundStyle(theme.colors.secondaryText)
        }
    }
}
