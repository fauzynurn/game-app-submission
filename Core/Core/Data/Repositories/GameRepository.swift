//
//  GameRepository.swift
//  Core
//
//  Created by Fauzi Nur Noviansyah on 07/07/24.
//

import Combine
import SwiftData
import SwiftUI

public protocol GameRepositoryProtocol {
    func getGameList(withQuery query: String) -> AnyPublisher<[Game], Error>

    func getGameDetail(withId id: String) -> AnyPublisher<Game, Error>

    func addGameToFavorite(game: Game) -> AnyPublisher<Bool, Error>

    func removeGameFromFavorite(withId id: Int) -> AnyPublisher<Bool, Error>

    func getFavoriteGameState(for id: Int) -> AnyPublisher<Bool, Error>

    func getFavoriteList() -> AnyPublisher<[Game], Error>
}

public class GameRepositoryImpl: GameRepositoryProtocol {
    let gameRemoteDataSource: GameRemoteDataSourceProtocol
    let gameLocalDataSource: GameLocalDataSourceProtocol

    public init(gameRemoteDataSource: GameRemoteDataSourceProtocol,
                gameLocalDataSource: GameLocalDataSourceProtocol) {
        self.gameRemoteDataSource = gameRemoteDataSource
        self.gameLocalDataSource = gameLocalDataSource
    }

    public func addGameToFavorite(game: Game) -> AnyPublisher<Bool, any Error> {
        let gameModel = game.toModel()
        return gameLocalDataSource.addGameToFavorite(game: gameModel).eraseToAnyPublisher()
    }

    public func removeGameFromFavorite(withId id: Int) -> AnyPublisher<Bool, any Error> {
        return gameLocalDataSource.removeGameFromFavorite(withId: id).eraseToAnyPublisher()
    }

    public func getGameList(withQuery query: String) -> AnyPublisher<[Game], any Error> {
        return gameRemoteDataSource.getGameList(withQuery: query).map {
            $0.toEntities()
        }.eraseToAnyPublisher()
    }

    public func getGameDetail(withId id: String) -> AnyPublisher<Game, any Error> {
        return gameRemoteDataSource.getGameDetail(withId: id).map {
            $0.toEntity()
        }.eraseToAnyPublisher()
    }

    public func getFavoriteGameState(for id: Int) -> AnyPublisher<Bool, any Error> {
        return gameLocalDataSource.getFavoriteGameState(for: id)
    }

    public func getFavoriteList() -> AnyPublisher<[Game], any Error> {
        return gameLocalDataSource.getFavoriteList().map {
            $0.toEntities()
        }.eraseToAnyPublisher()
    }
}
