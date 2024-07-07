//
//  SearchView.swift
//  gameappsubmission
//
//  Created by Fauzi Nur Noviansyah on 09/06/24.
//

import SwiftUI
import SwiftData
import Core
import Search

struct AppSearchListView: View {
    var body: some View {
        NavigationView {
            SearchListView(
                action: { gameId in
                GameDetailRouter.makeGameDetailView(gameId: "\(gameId)")
            })
            .navigationTitle(
                Text(
                    "Search"
                )
            )
        }
    }
}
