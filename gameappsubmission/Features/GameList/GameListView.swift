//
//  GameListView.swift
//  gameappsubmission
//
//  Created by Fauzi Nur Noviansyah on 08/06/24.
//

import SwiftUI

struct GameListView: View {
    @StateObject var viewModel = GameViewModel()
    @State var query: String = ""
    
    var body: some View {
        NavigationView {
            GameList(viewModel: viewModel)
                .task {
                    if viewModel.gameList.data == nil {
                        await viewModel.getGameList()
                    }
                }.navigationTitle(
                    Text(
                        "Games"
                    )
                )
        }
    }
}

struct GameList: View {
    @ObservedObject var viewModel: GameViewModel
    
    var body: some View {
        viewModel.gameList.toView(
            onSuccess: {
                data in List(
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



#Preview {
    return GameListView()
}
