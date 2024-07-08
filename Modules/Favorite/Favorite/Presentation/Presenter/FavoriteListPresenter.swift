//
//  FavoriteListPresenter.swift
//  Favorite
//
//  Created by Fauzi Nur Noviansyah on 07/07/24.
//

import Foundation
import Core
import Combine

public class FavoriteListPresenter: ObservableObject {
    private let getFavoriteListUseCase: GetFavoriteListUseCase

    @Published var favoriteList: AsyncResult<[Game], Error>

    private var cancellables: Set<AnyCancellable> = []

    public init(getFavoriteListUseCase: GetFavoriteListUseCase) {
        self.favoriteList = .initial
        self.getFavoriteListUseCase = getFavoriteListUseCase
    }

    @MainActor func getFavoriteList() async {
        favoriteList = .loading
        getFavoriteListUseCase.execute()
            .receive(on: RunLoop.main)
            .sink(
                receiveCompletion: { completion in
                    switch completion {
                        case .failure(let error): self.favoriteList = .failure(error)
                        default: {}()
                    }
                },
                receiveValue: { data in
                    self.favoriteList = .success(data)
                }).store(in: &cancellables)
    }
}
