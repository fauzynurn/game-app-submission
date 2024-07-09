//
//  GameDetailPresenter.swift
//  Detail
//
//  Created by Fauzi Nur Noviansyah on 08/07/24.
//

import Foundation
import Core
import Combine
import UIKit

public class GameDetailPresenter: ObservableObject {
    let getGameDetailUseCase: GetGameDetailUseCase
    let addGameToFavoriteUseCase: AddGameToFavoriteUseCase
    let removeGameFromFavoriteUseCase: RemoveGameFromFavoriteUseCase
    let getGameFavoriteStateUseCase: GetGameFavoriteStateUseCase

    @Published var gameDetail: AsyncResult<Game, Error>
    @Published var isFavorite: Bool

    private var cancellables: Set<AnyCancellable> = []

    public init(getGameDetailUseCase: GetGameDetailUseCase,
                getGameFavoriteStateUseCase: GetGameFavoriteStateUseCase,
                addGameToFavoriteUseCase: AddGameToFavoriteUseCase,
                removeGameFromFavoriteUseCase: RemoveGameFromFavoriteUseCase
    ) {
        self.gameDetail = .initial
        self.isFavorite = false

        self.getGameDetailUseCase = getGameDetailUseCase
        self.getGameFavoriteStateUseCase = getGameFavoriteStateUseCase
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
                    case .failure(let error):
                        self.gameDetail = .failure(error)
                    default: {}()
                    }
                },
                receiveValue: { data in
                    self.gameDetail = .success(data)
                    self.getFavoriteGameState(for: data.id)
                }).store(in: &cancellables)
    }

    func getFavoriteGameState(for id: Int) {
        getGameFavoriteStateUseCase.execute(for: id)
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
                        case .failure(let error):
                            print("an error occurred while adding game to favorite \(error)")
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
                    case .failure(let error):
                        print("an error occurred while removing game from favorite \(error)")
                    default: {}()
                    }
                },
                receiveValue: {_ in })
            .store(in: &cancellables)
    }
}
