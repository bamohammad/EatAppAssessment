//
//  RestaurantDetailsViewModel.swift
//  EatAppAssessment
//
//  Created by Ali Bamohammad on 19/06/2025.
//


import SwiftUI

@MainActor
final class RestaurantDetailsViewModel: ObservableObject {
    // MARK: - Published
    @Published private(set) var state: Loadable<RestaurantDetails> = .idle
    @Published private(set) var isRefreshing: Bool = false

    // MARK: - Dependencies
    private let useCase: GetRestaurantDetailsUseCase
    private var fetchTask: Task<Void, Never>?

    // MARK: - Init
    init(useCase: GetRestaurantDetailsUseCase) {
        self.useCase = useCase
    }

    // MARK: - Public API

    func loadDetails(for id: String) {
        cancelCurrentTask()
        state = .loading
        fetchDetails(id: id, isRefresh: false)
    }

    func refresh(id: String) async {
        guard !state.isLoading && !isRefreshing else { return }
        cancelCurrentTask()
        isRefreshing = true
        fetchDetails(id: id, isRefresh: true)
    }

    // MARK: - Private Helpers

    private func fetchDetails(id: String, isRefresh: Bool) {
        let existing = state.value

        fetchTask = Task {
            do {
                let details = try await useCase.execute(id: id)
                state = .loaded(details)
                isRefreshing = false
            } catch {
                state = isRefresh && existing != nil
                    ? .loaded(existing!)
                    : .failed(error)
                isRefreshing = false
            }
        }
    }

    private func cancelCurrentTask() {
        fetchTask?.cancel()
        fetchTask = nil
    }
}
