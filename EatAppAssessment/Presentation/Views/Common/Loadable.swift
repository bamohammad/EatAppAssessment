//
//  Loadable.swift
//  EatAppAssessment
//
//  Created by Ali Bamohammad on 18/06/2025.
//

import SwiftUI

// MARK: - LoadableView

@MainActor
struct LoadableView<Value, Content: View>: View {
    
    // MARK: - Properties
    
    let state: Loadable<Value>
    let retryAction: (() -> Void)?
    let isLoadingMore: Bool
    let content: (Value) -> Content
    @Environment(\.theme) private var theme

    // MARK: - Initialization
    
    init(
        state: Loadable<Value>,
        isLoadingMore: Bool = false,
        retryAction: (() -> Void)? = nil,
        @ViewBuilder content: @escaping (Value) -> Content
    ) {
        self.state = state
        self.retryAction = retryAction
        self.isLoadingMore = isLoadingMore
        self.content = content
    }

    // MARK: - Body
    
    var body: some View {
        switch state {
        case .idle, .loading:
            loadingView
            
        case .loaded(let value):
            loadedView(value: value)
            
        case .failed(let error):
            errorView(error: error)
        }
    }
}

// MARK: - View Components

private extension LoadableView {
    var loadingView: some View {
        VStack(spacing: 16) {
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle(tint: theme.colors.text))
                .scaleEffect(1.2)
            
            Text("Loading…")
                .font(.body)
                .foregroundColor(theme.colors.secondaryText)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(theme.colors.background)
    }
    
    func loadedView(value: Value) -> some View {
        ZStack(alignment: .bottom) {
            content(value)
            
            if isLoadingMore {
                loadingMoreIndicator
            }
        }
    }
    
    var loadingMoreIndicator: some View {
        HStack(spacing: 12) {
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle(tint: theme.colors.text))
                .scaleEffect(0.8)
            
            Text("Loading more…")
                .font(.caption)
                .foregroundColor(theme.colors.text)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(.ultraThinMaterial)
                .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
        )
        .padding(.bottom, 20)
    }
    
    func errorView(error: Error) -> some View {
        VStack(spacing: 24) {
            errorIcon
            errorContent(error: error)
            
            if let retryAction = retryAction {
                retryButton(action: retryAction)
            }
        }
        .padding(32)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(theme.colors.background)
    }
    
    var errorIcon: some View {
        Image(systemName: "externaldrive.fill.badge.xmark")
            .font(.system(size: 48, weight: .light))
            .foregroundColor(theme.colors.secondaryText)
            .padding(.bottom, 8)
    }
    
    func errorContent(error: Error) -> some View {
        VStack(spacing: 12) {
            Text("Failed to Load")
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundColor(theme.colors.text)
            
            Text(error.localizedDescription)
                .font(.body)
                .foregroundColor(theme.colors.secondaryText)
                .multilineTextAlignment(.center)
                .lineLimit(nil)
        }
    }
    
    func retryButton(action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack(spacing: 8) {
                Image(systemName: "arrow.clockwise")
                    .font(.system(size: 14, weight: .medium))
                
                Text("Retry")
                    .font(.body)
                    .fontWeight(.medium)
            }
            .foregroundColor(.white)
            .padding(.horizontal, 24)
            .padding(.vertical, 12)
            .background(
                RoundedRectangle(cornerRadius: 24)
                    .fill(theme.colors.text)
            )
        }
        .buttonStyle(RetryButtonStyle())
    }
}

// MARK: - Button Styles

private struct RetryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.96 : 1.0)
            .opacity(configuration.isPressed ? 0.8 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
    }
}


// MARK: - Preview Support

#if DEBUG
struct LoadableView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            // Loading state
            LoadableView(
                state: .loading as Loadable<String>,
                retryAction: {}
            ) { value in
                Text(value)
            }
            .previewDisplayName("Loading")
            
            // Loaded state
            LoadableView(
                state: .loaded("Content"),
                isLoadingMore: true,
                retryAction: {}
            ) { value in
                Text(value)
                    .padding()
            }
            .previewDisplayName("Loaded with More Loading")
            
            // Error state
            LoadableView(
                state: .failed(URLError(.notConnectedToInternet)) as Loadable<String>,
                retryAction: {}
            ) { value in
                Text(value)
            }
            .previewDisplayName("Error")
        }
    }
}
#endif
