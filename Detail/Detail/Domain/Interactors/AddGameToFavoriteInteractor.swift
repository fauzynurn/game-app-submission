//
//  AddGameToFavoritesInteractor.swift
//  Detail
//
//  Created by Fauzi Nur Noviansyah on 08/07/24.
//

import Foundation
import Combine
import Core

public protocol AddGameToFavoriteUseCase {
    func execute(game: Game) -> AnyPublisher<Bool, Error>
}

public class AddGameToFavoriteInteractor: AddGameToFavoriteUseCase {
    private let repository: GameRepositoryProtocol
    public required init(repository: GameRepositoryProtocol) {
        self.repository = repository
    }
    public func execute(game: Game) -> AnyPublisher<Bool, Error> {
        return repository.addGameToFavorite(game: game)
    }
}
