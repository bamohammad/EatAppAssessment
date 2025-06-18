//
//  RestaurantDetailView.swift
//  EatAppAssessment
//
//  Created by Ali Bamohammad on 18/06/2025.
//

import SwiftUI

// MARK: - RestaurantDetailView

struct RestaurantDetailView: View {
    @StateObject private var viewModel: RestaurantDetailsViewModel
    private let restaurantId: String

    init(viewModel: RestaurantDetailsViewModel, restaurantId: String) {
        _viewModel = StateObject(wrappedValue: viewModel)
        self.restaurantId = restaurantId
    }

    var body: some View {
        LoadableView(
            state: viewModel.state,
            retryAction: { viewModel.loadDetails(for: restaurantId) }
        ) { details in
            RestaurantDetailContent(restaurant: details)
                .refreshable {
                    await viewModel.refresh(id: details.id)
                }
        }
        .task {
            viewModel.loadDetails(for: restaurantId)
        }
    }
}

// MARK: - RestaurantDetailContent

private struct RestaurantDetailContent: View {
    let restaurant: RestaurantDetails

    @EnvironmentObject private var appNavigation: AppNavigation
    @Environment(\.theme) private var theme
    @State private var scrollOffset: CGFloat = 0

    private enum Constants {
        static let headerHeight: CGFloat = 300
        static let contentOffset: CGFloat = -90
        static let contentCornerRadius: CGFloat = 36
        static let contentTopPadding: CGFloat = 20
        static let horizontalPadding: CGFloat = 20
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                headerImageView
                mainContentView
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbarColorScheme(.dark, for: .navigationBar)
        .ignoresSafeArea(.container, edges: .top)
    }
}

// MARK: - Header Components

private extension RestaurantDetailContent {
    var headerImageView: some View {
        GeometryReader { geometry in
            StretchyHeaderImage(
                imageUrl: restaurant.imageUrl,
                geometry: geometry,
                headerHeight: Constants.headerHeight,
                scrollOffset: $scrollOffset
            )
        }
        .frame(height: Constants.headerHeight)
    }
}

// MARK: - Content Components

private extension RestaurantDetailContent {
    var mainContentView: some View {
        VStack(spacing: 24) {
            restaurantInfoSection

            if let notice = restaurant.notice {
                NoticeSection(notice: notice)
            }

            tagsSection
            relatedVenuesSection
            nearbyVenuesSection
        }
        .padding(.top, Constants.contentTopPadding)
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: Constants.contentCornerRadius))
        .offset(y: Constants.contentOffset)
    }

    var restaurantInfoSection: some View {
        RestaurantInfoSection(restaurant: restaurant)
            .padding(.horizontal, Constants.horizontalPadding)
    }

    var tagsSection: some View {
        TagsSection(labels: restaurant.labels)
            .padding(.horizontal, Constants.horizontalPadding)
    }

    /// since there is no API for this section I mocked the data
    var relatedVenuesSection: some View {
        VenuesSection(
            title: "Other venues with \(restaurant.cuisine)",
            venues: MockVenuesData.relatedVenues
        )
    }

    /// since there is no API for this section I mocked the data
    var nearbyVenuesSection: some View {
        VenuesSection(
            title: "Other venues in Business Bay",
            venues: MockVenuesData.nearbyVenues
        )
    }
}

// MARK: - StretchyHeaderImage

private struct StretchyHeaderImage: View {
    let imageUrl: URL?
    let geometry: GeometryProxy
    let headerHeight: CGFloat
    @Binding var scrollOffset: CGFloat

    private var offset: CGFloat {
        geometry.frame(in: .global).minY
    }

    private var calculatedHeight: CGFloat {
        headerHeight + (offset > 0 ? offset : 0)
    }

    var body: some View {
        AsyncImage(url: imageUrl) { phase in
            switch phase {
            case let .success(image):
                successImageView(image)
            case .failure:
                placeholderView(content: Image(systemName: "photo"))
            case .empty:
                placeholderView(content: ProgressView().progressViewStyle(CircularProgressViewStyle(tint: .white)))
            @unknown default:
                EmptyView()
            }
        }
        .onAppear {
            scrollOffset = offset
        }
        .onChange(of: offset) { _, newValue in
            scrollOffset = newValue
        }
    }

    private func successImageView(_ image: Image) -> some View {
        image
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: geometry.size.width, height: calculatedHeight)
            .overlay(
                LinearGradient(
                    colors: [.black.opacity(0.5), .clear],
                    startPoint: .top,
                    endPoint: .bottom
                )
            )
            .clipped()
            .offset(y: offset > 0 ? -offset : 0)
    }

    private func placeholderView<Content: View>(content: Content) -> some View {
        Rectangle()
            .fill(Color.gray.opacity(0.3))
            .frame(width: geometry.size.width, height: calculatedHeight)
            .overlay(content)
            .overlay(
                LinearGradient(
                    colors: [.black.opacity(0.5), .clear],
                    startPoint: .top,
                    endPoint: .bottom
                )
            )
            .clipped()
            .offset(y: offset > 0 ? -offset : 0)
    }
}

// MARK: - RestaurantInfoSection

private struct RestaurantInfoSection: View {
    let restaurant: RestaurantDetails
    @Environment(\.theme) private var theme

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            headerInfo
            descriptionText
            tagsRow
            locationRow
            menuRow
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private var headerInfo: some View {
        HStack(alignment: .center, spacing: 4) {
            Text(restaurant.name)
                .font(.title.bold())
                .foregroundColor(theme.colors.text)
            RatingView(rating: String(format: "%.1f", restaurant.rating))
            Spacer()
        }
    }

    private var descriptionText: some View {
        Text(restaurant.description)
            .font(.body)
            .foregroundColor(theme.colors.secondaryText)
            .lineLimit(nil)
    }

    private var tagsRow: some View {
        HStack(spacing: 16) {
            PriceIndicatorView(
                price: restaurant.priceLevel.symbol,
                style: .primary
            )
            CuisineView(cuisine: restaurant.cuisine)
        }
    }

    private var locationRow: some View {
        InfoRowView(
            icon: "location",
            title: restaurant.location.address.fullAddress,
            subtitle: "See venue's address in google maps",
            hasChevron: true
        )
        .padding(.vertical, 8)
    }

    private var menuRow: some View {
        InfoRowView(
            icon: "menu",
            title: "Restaurant menu",
            subtitle: "See restaurant menu in pdf",
            hasChevron: true
        )
        .padding(.vertical, 8)
    }
}

// MARK: - Supporting Views

private struct NoticeSection: View {
    let notice: String
    @Environment(\.theme) private var theme

    private enum Constants {
        static let verticalPadding: CGFloat = 12
        static let horizontalPadding: CGFloat = 16
        static let outerHorizontalPadding: CGFloat = 24
        static let cornerRadius: CGFloat = 20
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Notes from the restaurant")
                .font(.headline)
                .fontWeight(.semibold)
                .foregroundColor(theme.colors.text)

            Text(notice)
                .font(.body)
                .foregroundColor(theme.colors.text)
        }
        .padding(.vertical, Constants.verticalPadding)
        .padding(.horizontal, Constants.horizontalPadding)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(theme.colors.gradientTealSeafoam)
        .clipShape(RoundedRectangle(cornerRadius: Constants.cornerRadius))
        .padding(.horizontal, Constants.outerHorizontalPadding)
    }
}

private struct TagsSection: View {
    let labels: [RestaurantLabel]
    @Environment(\.theme) private var theme

    var body: some View {
        AnyLayout(FlowLayout(alignment: .init(horizontal: .leading, vertical: .center))) {
            ForEach(labels.indices, id: \.self) { index in
                TagView(
                    title: labels[index].displayName,
                    backgroundColor: theme.colors.backgroundLight
                )
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

// MARK: - CuisineView

private struct CuisineView: View {
    let cuisine: String
    @Environment(\.theme) private var theme

    private enum Constants {
        static let horizontalPadding: CGFloat = 18
        static let verticalPadding: CGFloat = 8
    }

    var body: some View {
        HStack {
            Image("cutlery")
            Text(cuisine)
                .foregroundColor(theme.colors.text)
                .font(.caption)
        }
        .font(.caption)
        .padding(.horizontal, Constants.horizontalPadding)
        .padding(.vertical, Constants.verticalPadding)
        .background(theme.colors.gradientMintGold)
        .clipShape(Capsule())
    }
}

// MARK: - InfoRowView

private struct InfoRowView: View {
    let icon: String
    let title: String
    let subtitle: String
    let hasChevron: Bool
    @Environment(\.theme) private var theme

    var body: some View {
        HStack {
            Image(icon)
                .foregroundColor(theme.colors.secondaryText)

            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(theme.colors.text)
                Text(subtitle)
                    .font(.caption)
                    .foregroundColor(.blue)
            }

            Spacer()

            if hasChevron {
                Image(systemName: "chevron.right")
                    .foregroundColor(theme.colors.secondaryText)
                    .font(.caption)
            }
        }
    }
}
