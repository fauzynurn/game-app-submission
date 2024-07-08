//
//  RemoveGameFromFavoriteInteractort.swift
//  Detail
//
//  Created by Fauzi Nur Noviansyah on 08/07/24.
//

import Foundation
import Combine
import Core

public protocol RemoveGameFromFavoriteUseCase {
    func execute(withId id: Int) -> AnyPublisher<Bool, Error>
}

public class RemoveGameFromFavoriteInteractor: RemoveGameFromFavoriteUseCase {
    private let repository: GameRepositoryProtocol
    public required init(repository: GameRepositoryProtocol) {
        self.repository = repository
    }
    public func execute(withId id: Int) -> AnyPublisher<Bool, Error> {
        return repository.removeGameFromFavorite(withId: id)
    }
}
