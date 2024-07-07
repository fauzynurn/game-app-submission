//
//  Result.swift
//  gameappsubmission
//
//  Created by Fauzi Nur Noviansyah on 08/06/24.
//

import SwiftUI

enum AsyncResult<Success, Failure: Error> {
    case initial
    case success(Success)
    case loading
    case failure(Failure)
}

extension AsyncResult {
    var data: Success? {
        if case let AsyncResult.success(data) = self {
            return data
        } else {
            return nil
        }
    }

    @ViewBuilder
    func toView(
        @ViewBuilder onSuccess: (Success) -> some View,
        @ViewBuilder onError: (Failure) -> some View,
        @ViewBuilder onLoading: () -> some View) -> some View {
            switch self {
            case .loading: onLoading()
            case .success(let data): onSuccess(data)
            case .failure(let error): onError(error)
            case .initial: Spacer()
            }
        }
}
