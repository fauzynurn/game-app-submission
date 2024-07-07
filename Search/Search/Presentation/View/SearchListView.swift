//
//  SearchView.swift
//  Search
//
//  Created by Fauzi Nur Noviansyah on 07/07/24.
//

import SwiftUI
import Core

public struct SearchListView<Destination: View>: View {
    @EnvironmentObject var presenter: SearchPresenter
    @State var query: String = ""

    let action: ((Int) -> Destination)

    public init(action: @escaping (Int) -> Destination) {
        self.action = action
    }

    public var body: some View {
        searchView
            .searchable(text: $query, prompt: "Game name")
            .onSubmit(of: .search) {
                presenter.searchGame(withQuery: query)
            }
    }

    @ViewBuilder
    var searchView: some View {
        if query.isEmpty {
            InitialSearch()
        } else {
            presenter.searchResult.toView(
                onSuccess: { data in
                    if !data.isEmpty {
                        List(
                            data
                        ) { game in
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
                            .navigate(to: self.action(game.id))
                            .listRowBackground(Color.clear)
                            .listRowSeparator(.hidden)
                            .listRowInsets(EdgeInsets(top: 8, leading: 0, bottom: 8, trailing: 0))
                        }
                    } else { EmptySearchResult() }
                },
                onError: { error in
                    if let err = error as? URLError, err.code == URLError.Code.notConnectedToInternet {
                        NoInternetConnectionView(onTapRetryButton: {
                            presenter.searchGame(withQuery: query)
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

struct InitialSearch: View {
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "magnifyingglass")
                .resizable()
                .frame(width: 50, height: 50)
            Text("Search result will be shown here")
                .multilineTextAlignment(.center)
        }
    }
}

#Preview {
    InitialSearch()
}

#Preview {
    EmptySearchResult()
}
