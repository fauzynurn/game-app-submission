//
//  GetGameDetailInteractor.swift
//  Detail
//
//  Created by Fauzi Nur Noviansyah on 08/07/24.
//

import Foundation
import Combine
import Core

public protocol GetGameDetailUseCase {
    func execute(withId id: String) -> AnyPublisher<Game, Error>
}

public class GetGameDetailInteractor: GetGameDetailUseCase {
    private let repository: GameRepositoryProtocol
    public required init(repository: GameRepositoryProtocol) {
        self.repository = repository
    }
    public func execute(withId id: String) -> AnyPublisher<Game, Error> {
        return repository.getGameDetail(withId: id)
    }
}
