//
//  GetGameFavoriteState.swift
//  Detail
//
//  Created by Fauzi Nur Noviansyah on 08/07/24.
//

import Foundation
import Combine
import Core

public protocol GetGameFavoriteStateUseCase {
    func execute(for id: Int) -> AnyPublisher<Bool, Error>
}

public class GetGameFavoriteStateInteractor: GetGameFavoriteStateUseCase {
    private let repository: GameRepositoryProtocol
    public required init(repository: GameRepositoryProtocol) {
        self.repository = repository
    }
    public func execute(for id: Int) -> AnyPublisher<Bool, Error> {
        return repository.getFavoriteGameState(for: id)
    }
}
