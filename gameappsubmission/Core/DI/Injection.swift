//
//  Injection.swift
//  gameappsubmission
//
//  Created by Fauzi Nur Noviansyah on 29/06/24.
//

import Foundation
import Swinject
import SwiftData

class Injection {
    
}

extension Injection {
    static let modelContainer: ModelContainer = {
        let configuration = ModelConfiguration(isStoredInMemoryOnly: true)
        do {
            let container = try ModelContainer(
                for: GameModel.self,
                configurations: configuration
            )
            return container
        } catch {
            fatalError("Error occurred while initializing ModelContainer: \(error)")
        }
    }()
    
    static let instance: Container = {
        let container = Container()
        
        /// Data sources
        container.register(GameRemoteDataSourceProtocol.self) {_ in GameRemoteDataSourceImpl()}
        container.register(GameLocalDataSourceProtocol.self) {_ in
            return GameLocalDataSourceImpl(context: ModelContext(modelContainer))
        }
        /// Repositories
        container.register(GameRepositoryProtocol.self) {_ in
            guard let remoteDataSource = container.resolve(GameRemoteDataSourceProtocol.self), let localDataSource = container.resolve(GameLocalDataSourceProtocol.self) else {fatalError("Error while initializing repository")}
            return GameRepositoryImpl(
                gameRemoteDataSource: remoteDataSource,
                gameLocalDataSource: localDataSource
            )
        }
        
        /// Interactors
        container.register(GetGameListUseCase.self) {_ in
            guard let repository = container.resolve(GameRepositoryProtocol.self) else {fatalError("Error while initializing interactor")}
            return GetGameListInteractor(
                repository: repository
            )
        }
        container.register(GetGameDetailUseCase.self) {_ in
            guard let repository = container.resolve(GameRepositoryProtocol.self) else {fatalError("Error while initializing interactor")}
            return GetGameDetailInteractor(
                repository: repository
            )
        }
        container.register(AddGameToFavoriteUseCase.self) {_ in
            guard let repository = container.resolve(GameRepositoryProtocol.self) else {fatalError("Error while initializing interactor")}
            return AddGameToFavoriteInteractor(
                repository: repository
            )
        }
        container.register(RemoveGameFromFavoriteUseCase.self) {_ in
            guard let repository = container.resolve(GameRepositoryProtocol.self) else {fatalError("Error while initializing interactor")}
            return RemoveGameFromFavoriteInteractor(
                repository: repository
            )
        }
        container.register(SearchGameUseCase.self) {_ in
            guard let repository = container.resolve(GameRepositoryProtocol.self) else {fatalError("Error while initializing interactor")}
            return SearchGameInteractor(
                repository: repository
            )
        }
        container.register(GetFavoriteStateUseCase.self) {_ in
            guard let repository = container.resolve(GameRepositoryProtocol.self) else {fatalError("Error while initializing interactor")}
            return GetFavoriteStateInteractor(
                repository: repository
            )
        }
        
        /// Presenter
        container.register(GameDetailRouter.self) {_ in GameDetailRouter()}
        container.register(GamePresenter.self) {_ in
            guard
                let getGameListUseCase = container.resolve(GetGameListUseCase.self),
                let searchGameUseCase = container.resolve(SearchGameUseCase.self),
                let gameDetailRouter = container.resolve(GameDetailRouter.self)
            else {fatalError("Error while initializing interactor")}
            return GamePresenter(
                getGameListUseCase: getGameListUseCase,
                searchGameUseCase: searchGameUseCase,
                gameDetailRouter: gameDetailRouter
            )
        }
        container.register(GameDetailPresenter.self) {_ in
            guard
                let getGameDetailUseCase = container.resolve(GetGameDetailUseCase.self),
                let addGameToFavoriteUseCase = container.resolve(AddGameToFavoriteUseCase.self),
                let removeGameFromFavoriteUseCase = container.resolve(RemoveGameFromFavoriteUseCase.self),
                let getFavoriteStateUseCase = container.resolve(GetFavoriteStateUseCase.self)
            else {fatalError("Error while initializing interactor")}
            return GameDetailPresenter(
                getGameDetailUseCase: getGameDetailUseCase,
                getFavoriteStateUseCase: getFavoriteStateUseCase,
                addGameToFavoriteUseCase: addGameToFavoriteUseCase,
                removeGameFromFavoriteUseCase: removeGameFromFavoriteUseCase
            )
        }.inObjectScope(.transient)
        
        return container
    }()
}
