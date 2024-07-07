//
//  GameDetailPresenter.swift
//  gameappsubmission
//
//  Created by Fauzi Nur Noviansyah on 29/06/24.
//

import Foundation
import UIKit
import SwiftData
import SwiftUI
import Combine
import Core

class GameDetailPresenter: ObservableObject {
    private let getGameDetailUseCase: GetGameDetailUseCase
    private let getFavoriteStateUseCase: GetFavoriteStateUseCase
    private let addGameToFavoriteUseCase: AddGameToFavoriteUseCase
    private let removeGameFromFavoriteUseCase: RemoveGameFromFavoriteUseCase

    @Published var gameDetail: AsyncResult<Game, Error>
    @Published var isFavorite: Bool

    private var cancellables: Set<AnyCancellable> = []

    init(getGameDetailUseCase: GetGameDetailUseCase,
         getFavoriteStateUseCase: GetFavoriteStateUseCase,
         addGameToFavoriteUseCase: AddGameToFavoriteUseCase,
         removeGameFromFavoriteUseCase: RemoveGameFromFavoriteUseCase
    ) {
        self.gameDetail = .initial
        self.isFavorite = false

        self.getGameDetailUseCase = getGameDetailUseCase
        self.getFavoriteStateUseCase = getFavoriteStateUseCase
        self.addGameToFavoriteUseCase = addGameToFavoriteUseCase
        self.removeGameFromFavoriteUseCase = removeGameFromFavoriteUseCase
    }

    func setFavoriteState() {
        if !isFavorite {
            addGameToFavorite()
        } else {
            removeGameFromFavorite()
        }
    }

    @MainActor func getGameDetail(withId id: String) async {
        gameDetail = .loading
        getGameDetailUseCase.execute(withId: id)
            .receive(on: RunLoop.main)
            .sink(
                receiveCompletion: { completion in
                    switch completion {
                    case .failure(let error): self.gameDetail = .failure(error)
                    default: {}()
                    }
                },
                receiveValue: { data in
                    self.gameDetail = .success(data)
                    self.getFavoriteGameState(for: data.id)
                }).store(in: &cancellables)
    }

    func getFavoriteGameState(for id: Int) {
        getFavoriteStateUseCase.execute(for: id)
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: {_ in },
                  receiveValue: { result in
                self.isFavorite = result
            }).store(in: &cancellables)
    }

    func openWebView(url: String) {
        let link = URL(string: url)
        guard let link = link else {return}
        UIApplication.shared.open(link)
    }

    func addGameToFavorite() {
        if let game = gameDetail.data {
            addGameToFavoriteUseCase.execute(game: game).receive(on: RunLoop.main)
                .sink(
                    receiveCompletion: { completion in
                        switch completion {
                        case .failure(let error): print("an error occurred while adding game to favorite \(error)")
                        default: {}()
                        }
                    },
                    receiveValue: {_ in })
                .store(in: &cancellables)
        }
    }

    func removeGameFromFavorite() {
        let id = gameDetail.data!.id
        removeGameFromFavoriteUseCase.execute(withId: id).receive(on: RunLoop.main)
            .sink(
                receiveCompletion: { completion in
                    switch completion {
                    case .failure(let error): print("an error occurred while removing game from favorite \(error)")
                    default: {}()
                    }
                },
                receiveValue: {_ in })
            .store(in: &cancellables)
    }
}
