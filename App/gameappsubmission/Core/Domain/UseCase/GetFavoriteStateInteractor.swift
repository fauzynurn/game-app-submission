//
//  GetFavoriteStateInteractor.swift
//  gameappsubmission
//
//  Created by Fauzi Nur Noviansyah on 29/06/24.
//

import Foundation
import Combine

protocol GetFavoriteStateUseCase {
    func execute(for id: Int) -> AnyPublisher<Bool, Error>
}

class GetFavoriteStateInteractor: GetFavoriteStateUseCase {
    private let repository: GameRepositoryProtocol
    required init(repository: GameRepositoryProtocol) {
        self.repository = repository
    }
    func execute(for id: Int) -> AnyPublisher<Bool, Error> {
        return repository.getFavoriteGameState(for: id)
    }
}
