//
//  RestaurantListViewModel.swift
//  EatAppAssessment
//
//  Created by Ali Bamohammad on 18/06/2025.
//

import Combine
import Foundation

@MainActor
final class RestaurantListViewModel: ObservableObject {
    // MARK: - Published Properties

    @Published private(set) var state: Loadable<[Restaurant]> = .idle
    @Published private(set) var isLoadingMore: Bool = false

    // MARK: - Dependencies

    private let useCase: GetRestaurantsUseCase
    private var fetchTask: Task<Void, Never>?
    private var isRefreshing = false

    // MARK: - Pagination

    private let pageSize = 10
    private var currentPage = 1
    private var totalPages = 1

    // MARK: - Init

    init(useCase: GetRestaurantsUseCase) {
        self.useCase = useCase
    }

    // MARK: - Public API

    func loadFirstPage() {
        cancelCurrentTask()
        resetPagination()
        setLoadingState()
        fetchRestaurants(page: 1, isRefresh: false)
    }

    func refresh() async {
        guard !state.isLoading, !isRefreshing else {
            return
        }
        cancelCurrentTask()
        resetPagination()
        isRefreshing = true
        fetchRestaurants(page: 1, isRefresh: true)
    }

    func loadNextPageIfNeeded(currentItem: Restaurant?) {
        guard shouldLoadNextPage(currentItem: currentItem) else {
            return
        }
        currentPage += 1
        isLoadingMore = true
        fetchRestaurants(page: currentPage, isRefresh: false)
    }

    // MARK: - Private Helpers

    private func resetPagination() {
        currentPage = 1
        totalPages = 1
    }

    private func setLoadingState() {
        state = .loading
        isLoadingMore = false
    }

    private func shouldLoadNextPage(currentItem: Restaurant?) -> Bool {
        guard let currentItem else {
            return false
        }
        return currentItem.id == state.value?.last?.id &&
            currentPage < totalPages &&
            !state.isLoading &&
            !isLoadingMore
    }

    private func fetchRestaurants(page: Int, isRefresh: Bool) {
        let existingItems = state.value ?? []

        fetchTask = Task { [weak self] in
            guard let self else {
                return
            }
            do {
                let response = try await useCase.execute(
                    regionId: "3906535a-d96c-47cf-99b0-009fc9e038e0",
                    page: page,
                    limit: pageSize
                )

                let combined = page == 1
                    ? response.restaurants
                    : existingItems + response.restaurants

                state = .loaded(combined)
                totalPages = response.pagination.totalPages
                isLoadingMore = false
                isRefreshing = false
            } catch {
                state = isRefresh ? .loaded(existingItems) : .failed(error)
                isLoadingMore = false
                isRefreshing = false
            }
        }
    }

    private func cancelCurrentTask() {
        fetchTask?.cancel()
        fetchTask = nil
    }
}
