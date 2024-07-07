//
//  GameRepository.swift
//  gameappsubmission
//
//  Created by Fauzi Nur Noviansyah on 25/06/24.
//

import Combine
import SwiftData
import SwiftUI

protocol GameRepositoryProtocol {
    func getGameList(withQuery query: String) -> AnyPublisher<[Game], Error>

    func getGameDetail(withId id: String) -> AnyPublisher<Game, Error>

    func addGameToFavorite(game: Game) -> AnyPublisher<Bool, Error>

    func removeGameFromFavorite(withId id: Int) -> AnyPublisher<Bool, Error>

    func getFavoriteGameState(for id: Int) -> AnyPublisher<Bool, Error>
}

class GameRepositoryImpl: GameRepositoryProtocol {
    let gameRemoteDataSource: GameRemoteDataSourceProtocol
    let gameLocalDataSource: GameLocalDataSourceProtocol

    init(gameRemoteDataSource: GameRemoteDataSourceProtocol, gameLocalDataSource: GameLocalDataSourceProtocol) {
        self.gameRemoteDataSource = gameRemoteDataSource
        self.gameLocalDataSource = gameLocalDataSource
    }

    func addGameToFavorite(game: Game) -> AnyPublisher<Bool, any Error> {
        let gameModel = game.toModel()
        return gameLocalDataSource.addGameToFavorite(game: gameModel).eraseToAnyPublisher()
    }

    func removeGameFromFavorite(withId id: Int) -> AnyPublisher<Bool, any Error> {
        return gameLocalDataSource.removeGameFromFavorite(withId: id).eraseToAnyPublisher()
    }

    func getGameList(withQuery query: String) -> AnyPublisher<[Game], any Error> {
        return gameRemoteDataSource.getGameList(withQuery: query).map {
            $0.toEntities()
        }.eraseToAnyPublisher()
    }

    func getGameDetail(withId id: String) -> AnyPublisher<Game, any Error> {
        return gameRemoteDataSource.getGameDetail(withId: id).map {
            $0.toEntity()
        }.eraseToAnyPublisher()
    }

    func getFavoriteGameState(for id: Int) -> AnyPublisher<Bool, any Error> {
        return gameLocalDataSource.getFavoriteGameState(for: id)
    }
}
