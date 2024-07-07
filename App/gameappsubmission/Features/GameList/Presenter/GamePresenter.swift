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
import Core

class GamePresenter: ObservableObject {
    let router: GameDetailRouter
    private let getGameListUseCase: GetGameListUseCase

    @Published var gameList: AsyncResult<[Game], Error>

    private var cancellables: Set<AnyCancellable> = []

    init(getGameListUseCase: GetGameListUseCase,
         gameDetailRouter: GameDetailRouter
    ) {
        self.gameList = .initial

        self.getGameListUseCase = getGameListUseCase
        self.router = gameDetailRouter
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
}
