//
//  GameListPresenter.swift
//  GameList
//
//  Created by Fauzi Nur Noviansyah on 07/07/24.
//

import Foundation
import UIKit
import SwiftData
import SwiftUI
import Combine
import Core

public class GameListPresenter: ObservableObject {
    private let getGameListUseCase: GetGameListUseCase

    @Published var gameList: AsyncResult<[Game], Error>

    private var cancellables: Set<AnyCancellable> = []

    public init(getGameListUseCase: GetGameListUseCase) {
        self.gameList = .initial

        self.getGameListUseCase = getGameListUseCase
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
