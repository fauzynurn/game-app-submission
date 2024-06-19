//
//  SearchView.swift
//  gameappsubmission
//
//  Created by Fauzi Nur Noviansyah on 09/06/24.
//

import SwiftUI

struct SearchListView: View {
    @StateObject var viewModel = GameViewModel()
    @State var query: String = ""
    
    var body: some View {
        NavigationView {
            SearchView(viewModel: viewModel)
                .searchable(text: $query, prompt: "Game name")
                .onSubmit(of: .search) {
                    viewModel.searchGame(withQuery: query)
                }.navigationTitle(
                    Text(
                        "Search"
                    )
                )
        }
    }
}

struct SearchView: View {
    @ObservedObject var viewModel: GameViewModel
    var body: some View {
        viewModel.searchResult.toView(
            onSuccess: {
                data in
                if !data.isEmpty {
                    List(
                        data
                    ) {
                        game in
                        NavigationLink(destination: GameDetailView(gameId: "\(game.id)")) {
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
                        }.listRowBackground(Color.clear)
                            .listRowSeparator(.hidden)
                            .listRowInsets(EdgeInsets(top: 8, leading: 0, bottom: 8, trailing: 0))
                    }
                } else { EmptySearchResult() }
            },
            onError: { error in
                if let err = error as? URLError, err.code == URLError.Code.notConnectedToInternet {
                    NoInternetConnectionView(onTapRetryButton: {
                        Task {
                            await viewModel.getGameList()
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
    @StateObject var viewModel: GameViewModel = GameViewModel()
    return SearchView(viewModel: viewModel)
}
