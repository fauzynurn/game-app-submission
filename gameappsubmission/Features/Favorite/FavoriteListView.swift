//
//  SearchView.swift
//  gameappsubmission
//
//  Created by Fauzi Nur Noviansyah on 09/06/24.
//

import SwiftUI
import SwiftData

struct FavoriteListView: View {
    var body: some View {
        NavigationView {
            FavoriteView()
                .navigationTitle(
                    Text(
                        "Favorite Game"
                    )
                )
        }
    }
}

struct FavoriteView: View {
    @Query var favoriteGameList: [Game]
    
    var body: some View {
        if !favoriteGameList.isEmpty {
            List(
                favoriteGameList
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
        } else { FavoriteEmptyState() }
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
    EmptySearchResult()
}

#Preview {
    return FavoriteListView()
}
