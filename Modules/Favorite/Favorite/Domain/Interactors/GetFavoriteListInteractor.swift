//
//  GetFavoriteListUseCase.swift
//  Search
//
//  Created by Fauzi Nur Noviansyah on 07/07/24.
//

import Foundation
import Combine
import Core

public protocol GetFavoriteListUseCase {
    func execute() -> AnyPublisher<[Game], Error>
}

public class GetFavoriteListInteractor: GetFavoriteListUseCase {
    private let repository: GameRepositoryProtocol
    public required init(repository: GameRepositoryProtocol) {
        self.repository = repository
    }
    public func execute() -> AnyPublisher<[Game], Error> {
        return repository.getFavoriteList()
    }
}
