//
//  SearchGameInteractor.swift
//  gameappsubmission
//
//  Created by Fauzi Nur Noviansyah on 26/06/24.
//

import Foundation
import Combine

protocol SearchGameUseCase {
    func execute(withQuery query: String) -> AnyPublisher<[Game], Error>
}

class SearchGameInteractor: SearchGameUseCase {
    private let repository: GameRepositoryProtocol
    
    required init(repository: GameRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute(withQuery query: String) -> AnyPublisher<[Game], Error> {
        return repository.getGameList(withQuery: query)
    }
}
