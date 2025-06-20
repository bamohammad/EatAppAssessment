//
//  RestaurantListView.swift
//  EatAppAssessment
//
//  Created by Ali Bamohammad on 18/06/2025.
//

import SwiftUI

// MARK: - RestaurantListView

struct RestaurantListView: View {
    @StateObject private var viewModel: RestaurantListViewModel
    @EnvironmentObject private var appNavigation: AppNavigation
    @Environment(\.theme) private var theme

    init(viewModel: RestaurantListViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        NavigationStack(path: $appNavigation.path) {
            LoadableView(
                state: viewModel.state,
                isLoadingMore: viewModel.isLoadingMore,
                retryAction: viewModel.loadFirstPage
            ) { restaurants in
                restaurantList(restaurants)
            }
            .navigationTitle("Restaurants")
            .navigationBarTitleDisplayMode(.large)
            .toolbarBackground(theme.colors.background, for: .navigationBar)
            .navigationDestination(for: AppNavigation.Route.self) { route in
                destinationView(for: route)
            }
        }
        .preferredColorScheme(theme.colorScheme)
        .accentColor(.white)
        .task {
            viewModel.loadFirstPage()
        }
    }
}

// MARK: - Private Extensions

private extension RestaurantListView {
    func restaurantList(_ restaurants: [Restaurant]) -> some View {
        List {
            ForEach(restaurants) { restaurant in
                RestaurantRowView(restaurant: restaurant)
                    .onAppear {
                        viewModel.loadNextPageIfNeeded(currentItem: restaurant)
                    }
                    .listRowSeparator(.hidden)
                    .listRowBackground(Color.clear)
                    .listRowInsets(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
                    .onTapGesture {
                        handleRestaurantSelection(restaurant)
                    }
            }
        }
        .listStyle(.plain)
        .background(theme.colors.background)
        .scrollContentBackground(.hidden)
        .refreshable {
            await viewModel.refresh()
        }
    }

    private func handleRestaurantSelection(_ restaurant: Restaurant) {
        // Add haptic feedback for better UX
        let impactFeedback = UIImpactFeedbackGenerator(style: .light)
        impactFeedback.impactOccurred()

        appNavigation.navigate(route: .restaurantDetails(restaurant: restaurant))
    }

    @ViewBuilder
    func destinationView(for route: AppNavigation.Route) -> some View {
        switch route {
        case let .restaurantDetails(restaurant):
            RestaurantDetailView(
                viewModel: RestaurantDetailsViewModel(
                    useCase: DIContainer.shared.resolve()
                ),
                restaurantId: restaurant.id
            )
        }
    }
}

// MARK: - RestaurantRowView

private struct RestaurantRowView: View {
    let restaurant: Restaurant
    @Environment(\.theme) private var theme

    private enum Constants {
        static let imageHeight: CGFloat = 242
        static let cornerRadius: CGFloat = 36
        static let contentPadding: CGFloat = 16
        static let verticalSpacing: CGFloat = 8
    }

    var body: some View {
        VStack(alignment: .leading, spacing: Constants.verticalSpacing) {
            restaurantHeader
            restaurantImageContainer
        }
    }
}

// MARK: - RestaurantRowView Components

private extension RestaurantRowView {
    var restaurantHeader: some View {
        VStack(alignment: .leading, spacing: Constants.verticalSpacing) {
            restaurantTitle
            restaurantSubtitle
        }
        .padding(.horizontal, Constants.contentPadding)
        .padding(.top, Constants.contentPadding)
    }

    var restaurantTitle: some View {
        Text(restaurant.name)
            .font(.title.weight(.bold))
            .foregroundColor(theme.colors.text)
    }

    var restaurantSubtitle: some View {
        HStack {
            Text(restaurant.location?.address ?? "")
                .font(.caption.weight(.bold))
                .foregroundColor(theme.colors.secondaryText)

            Spacer()

            RatingView(rating:restaurant.formattedRating)
        }
    }

    var restaurantImageContainer: some View {
        ZStack(alignment: .bottomLeading) {
            restaurantImage
            restaurantTags
        }
    }

    var restaurantImage: some View {
        GeometryReader { geometry in
            AsyncImage(url: restaurant.imageUrl) { phase in
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

    var restaurantTags: some View {
        VStack(alignment: .leading, spacing: Constants.verticalSpacing) {
            RestaurantTagView(
                title: restaurant.priceLevel.symbol,
                backgroundColor: theme.colors.background
            )

            RestaurantTagView(
                title: restaurant.cuisine,
                backgroundColor: theme.colors.background
            )
        }
        .padding(Constants.contentPadding)
    }
}


// MARK: - RestaurantTagView

private struct RestaurantTagView: View {
    let title: String
    let backgroundColor: Color

    var body: some View {
        AppTagView(
            title: title,
            backgroundColor: backgroundColor
        )
    }
}

// MARK: - RestaurantTagView

private struct AppTagView: View {
    let title: String
    let backgroundColor: Color

    var body: some View {
        TagView(
            title: title,
            backgroundColor: backgroundColor
        )
    }
}
