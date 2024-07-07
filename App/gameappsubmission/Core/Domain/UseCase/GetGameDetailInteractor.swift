//
//  GetGameDetailInteractor.swift
//  gameappsubmission
//
//  Created by Fauzi Nur Noviansyah on 25/06/24.
//

import Foundation
import Combine
import Core

protocol GetGameDetailUseCase {
    func execute(withId id: String) -> AnyPublisher<Game, Error>
}

class GetGameDetailInteractor: GetGameDetailUseCase {
    private let repository: GameRepositoryProtocol
    required init(repository: GameRepositoryProtocol) {
        self.repository = repository
    }
    func execute(withId id: String) -> AnyPublisher<Game, Error> {
        return repository.getGameDetail(withId: id)
    }
}
