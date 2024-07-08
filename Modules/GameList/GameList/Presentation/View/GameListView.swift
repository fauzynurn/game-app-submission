//
//  GameListView.swift
//  GameList
//
//  Created by Fauzi Nur Noviansyah on 07/07/24.
//

import SwiftUI
import Core

public struct GameListView<Destination: View>: View {
    @EnvironmentObject var presenter: GameListPresenter

    let action: ((Int) -> Destination)

    public init(action: @escaping (Int) -> Destination) {
        self.action = action
    }

    public var body: some View {
        gameList
            .task {
                if presenter.gameList.data == nil {
                    await presenter.getGameList()
                }
            }
    }

    var gameList: some View {
        presenter.gameList.toView(
            onSuccess: { data in
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
                    ).navigate(to: self.action(game.id))
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
    return GameListView(action: {_ in EmptyView()})
}
