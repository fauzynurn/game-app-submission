//
//  SearchView.swift
//  gameappsubmission
//
//  Created by Fauzi Nur Noviansyah on 09/06/24.
//

import SwiftUI
import SwiftData
import Core
import Favorite

struct AppFavoriteListView: View {
    var body: some View {
        NavigationView {
            FavoriteListView(
                action: { gameId in
                GameDetailRouter.makeGameDetailView(gameId: "\(gameId)")
            })
            .navigationTitle(
                Text(
                    "Favorite Game"
                )
            )
        }
    }
}
