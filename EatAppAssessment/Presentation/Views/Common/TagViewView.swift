//
//  TagViewView.swift
//  EatAppAssessment
//
//  Created by Ali Bamohammad on 19/06/2025.
//
import SwiftUI

struct TagView: View {
    @Environment(\.theme) private var theme
    let title: String
    var backgroundColor: Color? = nil
    var gradient: LinearGradient? = nil

    var body: some View {
        Text(title)
            .font(.caption.bold())
            .padding(.horizontal, 10)
            .padding(.vertical, 4)
            .background(Capsule().fill(gradient ?? LinearGradient(stops: [], startPoint: .top, endPoint: .bottom)))
            .background(Capsule().fill(backgroundColor ?? .clear))
    }
}
