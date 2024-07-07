//
//  GameViewController.swift
//  gameappsubmission
//
//  Created by Fauzi Nur Noviansyah on 10/06/24.
//

import Foundation
import UIKit
import SwiftData
import SwiftUI
import Combine

class GamePresenter: ObservableObject {
    let router: GameDetailRouter
    private let getGameListUseCase: GetGameListUseCase
    private let searchGameUseCase: SearchGameUseCase

    @Published var gameList: AsyncResult<[Game], Error>
    @Published var searchResult: AsyncResult<[Game], Error>

    private var cancellables: Set<AnyCancellable> = []

    init(getGameListUseCase: GetGameListUseCase,
         searchGameUseCase: SearchGameUseCase,
         gameDetailRouter: GameDetailRouter
    ) {
        self.gameList = .initial
        self.searchResult = .initial

        self.getGameListUseCase = getGameListUseCase
        self.searchGameUseCase = searchGameUseCase
        self.router = gameDetailRouter
    }

    func resetSearchResult() {
        searchResult = .initial
    }

    @MainActor func getGameList() async {
        gameList = .loading
        getGameListUseCase.execute()
            .receive(on: RunLoop.main)
            .sink(
                receiveCompletion: { completion in
                    switch completion {
                    case .failure(let error): self.gameList = .failure(error)
                    default: {}()
                    }
                },
                receiveValue: { data in
                    self.gameList = .success(data)
                }).store(in: &cancellables)
    }

    @MainActor func searchGame(withQuery query: String) {
        searchResult = .loading
        searchGameUseCase.execute(withQuery: query)
            .receive(on: RunLoop.main)
            .sink(
                receiveCompletion: { completion in
                    switch completion {
                    case .failure(let error): self.searchResult = .failure(error)
                    default: {}()
                    }
                },
                receiveValue: { data in
                    self.searchResult = .success(data)
                }).store(in: &cancellables)
    }
}
