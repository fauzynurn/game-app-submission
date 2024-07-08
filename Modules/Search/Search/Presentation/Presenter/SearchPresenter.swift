//
//  SearchPresenter.swift
//  Search
//
//  Created by Fauzi Nur Noviansyah on 07/07/24.
//

import Foundation
import Core
import Combine

public class SearchPresenter: ObservableObject {
    private let searchGameUseCase: SearchGameUseCase
    
    @Published var searchResult: AsyncResult<[Game], Error>

    private var cancellables: Set<AnyCancellable> = []

    public init(searchGameUseCase: SearchGameUseCase) {
        self.searchResult = .initial
        self.searchGameUseCase = searchGameUseCase
    }

    func resetSearchResult() {
        searchResult = .initial
    }

    @MainActor func searchGame(withQuery query: String) {
        searchResult = .loading
        searchGameUseCase.execute(withQuery: query)
            .receive(on: RunLoop.main)
            .sink(
                receiveCompletion: { completion in
                    switch completion {
                    case .failure(let error): self.searchResult = .failure(error)
                    default: {}()
                    }
                },
                receiveValue: { data in
                    self.searchResult = .success(data)
                }).store(in: &cancellables)
    }
}
