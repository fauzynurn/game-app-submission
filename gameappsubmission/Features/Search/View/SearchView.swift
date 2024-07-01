//
//  SearchView.swift
//  gameappsubmission
//
//  Created by Fauzi Nur Noviansyah on 09/06/24.
//

import SwiftUI

struct SearchListView: View {
    @EnvironmentObject var presenter: GamePresenter
    @State var query: String = ""
    
    var body: some View {
        NavigationView {
            SearchView()
                .searchable(text: $query, prompt: "Game name")
                .onSubmit(of: .search) {
                    presenter.searchGame(withQuery: query)
                }.navigationTitle(
                    Text(
                        "Search"
                    )
                )
        }
    }
}

struct SearchView: View {
    @EnvironmentObject var presenter: GamePresenter
    var body: some View {
        presenter.searchResult.toView(
            onSuccess: {
                data in
                if !data.isEmpty {
                    List(
                        data
                    ) {
                        game in
                        GameItemView(
                            imageUrl: game.imageUrl,
                            gameName: game.title,
                            supportedPlatformLabel: game.supportedPlatformLabel.joined(
                                separator: " | "
                            ),
                            ratingLabel: "\(game.rating)",
                            esrbRatingLabel: game.esrbRating,
                            releasedDate: game.releasedDate
                        )
                        .navigate(to: presenter.router.makeGameDetailView(gameId: "\(game.id)"))
                        .listRowBackground(Color.clear)
                        .listRowSeparator(.hidden)
                        .listRowInsets(EdgeInsets(top: 8, leading: 0, bottom: 8, trailing: 0))
                    }
                } else { EmptySearchResult() }
            },
            onError: { error in
                if let err = error as? URLError, err.code == URLError.Code.notConnectedToInternet {
                    NoInternetConnectionView(onTapRetryButton: {
                        Task {
                            await presenter.getGameList()
                        }
                    })
                } else {
                    Text(
                        "An error occurred"
                    )
                }
            },
            onLoading: {
                ProgressView()
            })
    }
}

struct EmptySearchResult: View {
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "magnifyingglass")
                .resizable()
                .frame(width: 50, height: 50)
            Text("Result not found. \nTry another keyword.")
                .multilineTextAlignment(.center)
        }
    }
}

#Preview {
    EmptySearchResult()
}

#Preview {
    return SearchView()
}
