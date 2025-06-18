//
//  SectionHeaderView.swift
//  EatAppAssessment
//
//  Created by Ali Bamohammad on 19/06/2025.
//
import SwiftUI

struct SectionHeaderView: View {
    let title: String
    @Environment(\.theme) private var theme

    var body: some View {
        Text(title)
            .font(.headline)
            .fontWeight(.semibold)
            .foregroundColor(theme.colors.text)
    }
}
