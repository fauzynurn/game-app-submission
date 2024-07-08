//
//  SearchGameInteractor.swift
//  Search
//
//  Created by Fauzi Nur Noviansyah on 07/07/24.
//

import Foundation
import Combine
import Core

public protocol SearchGameUseCase {
    func execute(withQuery query: String) -> AnyPublisher<[Game], Error>
}

public class SearchGameInteractor: SearchGameUseCase {
    private let repository: GameRepositoryProtocol
    public required init(repository: GameRepositoryProtocol) {
        self.repository = repository
    }
    public func execute(withQuery query: String) -> AnyPublisher<[Game], Error> {
        return repository.getGameList(withQuery: query)
    }
}
