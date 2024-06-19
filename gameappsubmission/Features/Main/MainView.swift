//
//  MainView.swift
//  gameappsubmission
//
//  Created by Fauzi Nur Noviansyah on 08/06/24.
//

import SwiftUI

struct MainView: View {
    var body: some View {
        TabView {
            GameListView().tabItem {
                Label(
                    "Games",
                    systemImage: "gamecontroller.fill"
                )
            }
            SearchListView()
                .tabItem {
                    Label(
                        "Search",
                        systemImage: "magnifyingglass"
                    )
                }
            AboutView()
                .tabItem {
                    Label(
                        "About",
                        systemImage: "person.fill"
                    )
                }
        }
    }
}

#Preview {
    MainView()
}