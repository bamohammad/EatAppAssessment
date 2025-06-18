//
//  LoadableEnum.swift
//  EatAppAssessment
//
//  Created by Ali Bamohammad on 19/06/2025.
//
import SwiftUI

@MainActor
enum Loadable<Value> {
    case idle
    case loading
    case loaded(Value)
    case failed(Error)

    var value: Value?  {
        if case .loaded(let v) = self { return v }
        return nil
    }

    var error: Error?  {
        if case .failed(let e) = self { return e }
        return nil
    }

    var isLoading: Bool {
        if case .loading = self { return true }
        return false
    }
}
