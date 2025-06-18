//
//  VenuesSection.swift
//  EatAppAssessment
//
//  Created by Ali Bamohammad on 19/06/2025.
//

import SwiftUI

// MARK: - VenuesSection

struct VenuesSection: View {
    let title: String
    let venues: [VenueCardData]
    @Environment(\.theme) private var theme

    private enum Constants {
        static let spacing: CGFloat = 16
        static let horizontalPadding: CGFloat = 20
    }

    var body: some View {
        VStack(alignment: .leading, spacing: Constants.spacing) {
            SectionHeaderView(title: title)
                .padding(.horizontal, Constants.horizontalPadding)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: Constants.spacing) {
                    ForEach(venues, id: \.name) { venue in
                        VenueCard(venue: venue)
                    }
                }
                .padding(.horizontal, Constants.horizontalPadding)
            }
        }
    }
}

// MARK: - VenuesSection

private struct VenueCard: View {
    let venue: VenueCardData
    @Environment(\.theme) private var theme

    private enum Constants {
        static let cardWidth: CGFloat = 160
        static let imageHeight: CGFloat = 120
        static let cornerRadius: CGFloat = 12
        static let badgeCornerRadius: CGFloat = 12
        static let badgePadding: CGFloat = 8
        static let spacing: CGFloat = 8
    }

    var body: some View {
        VStack(alignment: .leading, spacing: Constants.spacing) {
            venueImage
            venueInfo
        }
        .frame(width: Constants.cardWidth)
    }

    private var venueImage: some View {
        GeometryReader { geometry in
            AsyncImage(url: venue.image) { phase in
                switch phase {
                case let .success(image):
                    successImageView(image, geometry: geometry)
                case .failure:
                    placeholderImageView(geometry: geometry, isError: true)
                case .empty:
                    placeholderImageView(geometry: geometry, isError: false)
                @unknown default:
                    EmptyView()
                }
            }
        }
        .frame(height: Constants.imageHeight)
        .clipShape(RoundedRectangle(cornerRadius: Constants.cornerRadius))
    }

    private var ratingBadge: some View {
        HStack(spacing: 4) {
            Image(systemName: "star.fill")
                .foregroundColor(theme.colors.warmOrange)
                .font(.caption2)
            Text(venue.rating)
                .font(.caption2)
                .fontWeight(.medium)
                .foregroundColor(.white)
        }
        .padding(.horizontal, Constants.badgePadding)
        .padding(.vertical, 4)
        .background(.black.opacity(0.6))
        .cornerRadius(Constants.badgeCornerRadius)
        .padding(Constants.badgePadding)
    }

    private var venueInfo: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(venue.name)
                .font(.subheadline)
                .fontWeight(.medium)
                .foregroundColor(theme.colors.text)
                .lineLimit(1)

            HStack(spacing: 4) {
                Image(systemName: "fork.knife")
                    .font(.caption2)
                    .foregroundColor(theme.colors.text)
                Text(venue.cuisine)
                    .font(.caption)
                    .foregroundColor(theme.colors.text)
                    .lineLimit(1)
            }

            PriceIndicatorView(price: venue.price, style: .secondary)
        }
        .padding(.horizontal, 8)
        .padding(.bottom, 8)
    }
}
