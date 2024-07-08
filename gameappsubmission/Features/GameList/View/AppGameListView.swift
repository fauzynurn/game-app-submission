//
//  GameListView.swift
//  gameappsubmission
//
//  Created by Fauzi Nur Noviansyah on 08/06/24.
//

import SwiftUI
import GameList

struct AppGameListView: View {
    var body: some View {
        NavigationView {
            GameListView(action: { gameId in
                GameDetailRouter.makeGameDetailView(gameId: "\(gameId)")
            })
            .navigationTitle(
                Text(
                    "Games"
                )
            )
        }
    }
}
