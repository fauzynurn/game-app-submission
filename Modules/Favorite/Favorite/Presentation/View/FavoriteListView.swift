//
//  SearchView.swift
//  gameappsubmission
//
//  Created by Fauzi Nur Noviansyah on 09/06/24.
//

import SwiftUI
import SwiftData
import Core

public struct FavoriteListView<Destination: View>: View {
    @EnvironmentObject var presenter: FavoriteListPresenter
    
    let action: ((Int) -> Destination)

    public init(action: @escaping (Int) -> Destination) {
        self.action = action
    }

    public var body: some View {
        Group {
            if let list = presenter.favoriteList.data, !list.isEmpty {
                List(
                    list
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
            } else { FavoriteEmptyState() }
        }.task {
            await presenter.getFavoriteList()
        }
    }
}

struct FavoriteEmptyState: View {
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "heart.slash.fill")
                .resizable()
                .frame(width: 50, height: 50)
            Text("No favorite game")
                .multilineTextAlignment(.center)
        }
    }
}

#Preview {
    return FavoriteListView(action: { _ in EmptyView()})
}
