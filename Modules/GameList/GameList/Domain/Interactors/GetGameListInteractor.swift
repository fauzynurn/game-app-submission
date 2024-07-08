//
//  GetGameListInteractor.swift
//  GameList
//
//  Created by Fauzi Nur Noviansyah on 07/07/24.
//

import Foundation
import Combine
import Core

public protocol GetGameListUseCase {
    func execute() -> AnyPublisher<[Game], Error>
}

public class GetGameListInteractor: GetGameListUseCase {
    private let repository: GameRepositoryProtocol
    public required init(repository: GameRepositoryProtocol) {
        self.repository = repository
    }
    public func execute() -> AnyPublisher<[Game], Error> {
        return repository.getGameList(withQuery: "")
    }
}
