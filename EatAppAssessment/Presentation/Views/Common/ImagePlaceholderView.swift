//
//  ImagePlaceholderView.swift
//  EatAppAssessment
//
//  Created by Ali Bamohammad on 19/06/2025.
//
import SwiftUI


struct ImagePlaceholderView: View {
    let isError: Bool
    let width: CGFloat
    let height: CGFloat
    @Environment(\.theme) private var theme
    
    var body: some View {
        Rectangle()
            .fill(theme.colors.backgroundLight)
            .frame(width: width, height: height)
            .overlay(
                Group {
                    if isError {
                        Image(systemName: "photo")
                            .foregroundColor(theme.colors.secondaryText)
                            .font(.title2)
                    } else {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: theme.colors.text))
                    }
                }
            )
    }
}
