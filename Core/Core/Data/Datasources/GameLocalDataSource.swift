//
//  GameLocalDataSource.swift
//  Core
//
//  Created by Fauzi Nur Noviansyah on 05/07/24.
//

import Foundation
import Combine
import SwiftData
import SwiftUI

public protocol GameLocalDataSourceProtocol {
    func addGameToFavorite(game: GameModel) -> AnyPublisher<Bool, Error>
    func removeGameFromFavorite(withId id: Int) -> AnyPublisher<Bool, Error>
    func getFavoriteGameState(for id: Int) -> AnyPublisher<Bool, Error>
    func getFavoriteList() -> AnyPublisher<[GameModel], Error>
}

public class GameLocalDataSourceImpl: GameLocalDataSourceProtocol {
    let context: ModelContext
    let subject = CurrentValueSubject<[GameModel], Error>([GameModel]())

    public init(context: ModelContext) {
        self.context = context
    }

    public func getFavoriteGameState(for id: Int) -> AnyPublisher<Bool, Error> {
        let fetchFavoriteStateForCurrentId = subject.tryMap { _ in
            let favoriteList = try self.context.fetch(FetchDescriptor<GameModel>())
            return favoriteList
        }
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(didSave),
            name: .NSPersistentStoreRemoteChange,
            object: nil
        )

        return fetchFavoriteStateForCurrentId.map { data in
            let isFavorite = data.first(where: {$0.id == id})
            return isFavorite != nil
        }.eraseToAnyPublisher()

    }

    func fetch() throws {
        subject.send([GameModel]())
    }

    @objc func didSave(_ notification: Notification) {
        do {
            try fetch()
        } catch {}
    }

    public func addGameToFavorite(game: GameModel) -> AnyPublisher<Bool, Error> {
        return Future<Bool, Error> { completion in
            self.context.insert(game)
            completion(.success(true))
        }.eraseToAnyPublisher()
    }

    public func removeGameFromFavorite(withId id: Int) -> AnyPublisher<Bool, Error> {
        return Future<Bool, Error> { _ in
            do {
                try self.context.delete(model: GameModel.self, where: #Predicate {game in
                    return game.id == id})
            } catch {
                print("Error occurred while deleting data: \(error)")
            }
        }.eraseToAnyPublisher()
    }

    public func getFavoriteList() -> AnyPublisher<[GameModel], any Error> {
        return Future<[GameModel], Error> { completion in
            do {
                let favoriteList = try self.context.fetch(FetchDescriptor<GameModel>())
                completion(.success(favoriteList))
            } catch {
                completion(.failure(error))
            }
        }.eraseToAnyPublisher()
    }
}
