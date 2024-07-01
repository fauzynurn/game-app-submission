//
//  GetGameListInteractor.swift
//  gameappsubmission
//
//  Created by Fauzi Nur Noviansyah on 25/06/24.
//

import Foundation
import Combine

protocol GetGameListUseCase {
    func execute() -> AnyPublisher<[Game], Error>
}

class GetGameListInteractor: GetGameListUseCase {
    private let repository: GameRepositoryProtocol
    
    required init(repository: GameRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute() -> AnyPublisher<[Game], Error> {
        return repository.getGameList(withQuery: "")
    }
}
