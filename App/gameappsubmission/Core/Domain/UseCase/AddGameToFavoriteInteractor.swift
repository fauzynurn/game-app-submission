//
//  AddGameToFavoriteInteractor.swift
//  gameappsubmission
//
//  Created by Fauzi Nur Noviansyah on 26/06/24.
//

import Foundation
import Combine

protocol AddGameToFavoriteUseCase {
    func execute(game: Game) -> AnyPublisher<Bool, Error>
}

class AddGameToFavoriteInteractor: AddGameToFavoriteUseCase {
    private let repository: GameRepositoryProtocol
    required init(repository: GameRepositoryProtocol) {
        self.repository = repository
    }
    func execute(game: Game) -> AnyPublisher<Bool, Error> {
        return repository.addGameToFavorite(game: game)
    }
}
