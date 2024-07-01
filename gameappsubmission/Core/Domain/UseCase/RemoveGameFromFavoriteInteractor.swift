//
//  RemoveGameFromFavoriteInteractor.swift
//  gameappsubmission
//
//  Created by Fauzi Nur Noviansyah on 26/06/24.
//

import Foundation
import Combine

protocol RemoveGameFromFavoriteUseCase {
    func execute(withId id: Int) -> AnyPublisher<Bool, Error>
}

class RemoveGameFromFavoriteInteractor: RemoveGameFromFavoriteUseCase {
    private let repository: GameRepositoryProtocol
    
    required init(repository: GameRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute(withId id: Int) -> AnyPublisher<Bool, Error> {
        return repository.removeGameFromFavorite(withId: id)
    }
}
