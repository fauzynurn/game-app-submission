//
//  GameListView.swift
//  gameappsubmission
//
//  Created by Fauzi Nur Noviansyah on 08/06/24.
//

import SwiftUI

struct GameListView: View {
    @EnvironmentObject var presenter: GamePresenter
    @State var query: String = ""
    
    var body: some View {
        NavigationView {
            GameList()
                .task {
                    if presenter.gameList.data == nil {
                        await presenter.getGameList()
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
    @EnvironmentObject var presenter: GamePresenter
    
    var body: some View {
        presenter.gameList.toView(
            onSuccess: {
                data in List(
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
                    ).navigate(to: presenter.router.makeGameDetailView(gameId: "\(game.id)"))
                        .listRowBackground(Color.clear)
                        .listRowSeparator(.hidden)
                        .listRowInsets(EdgeInsets(top: 8, leading: 0, bottom: 8, trailing: 0))
                }
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



#Preview {
    return GameListView()
}
