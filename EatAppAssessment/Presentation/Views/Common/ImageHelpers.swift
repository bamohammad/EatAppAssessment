//
//  ImageHelpers.swift
//  EatAppAssessment
//
//  Created by Ali Bamohammad on 19/06/2025.
//
import SwiftUI

extension View {

    func successImageView(_ image: Image, geometry: GeometryProxy) -> some View {
        image
            .resizable()
            .scaledToFill()
            .frame(width: geometry.size.width, height: geometry.size.height)
    }

    func placeholderImageView(geometry: GeometryProxy, isError: Bool) -> some View {
        ImagePlaceholderView(
            isError: isError,
            width: geometry.size.width,
            height: geometry.size.height
        )
    }
}
