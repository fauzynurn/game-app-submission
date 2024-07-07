//
//  Main.swift
//  gameappsubmission
//
//  Created by Fauzi Nur Noviansyah on 08/06/24.
//

import SwiftUI
import SwiftData
import Swinject
import Core
import Favorite
import Search

@main
struct Main: App {
    var body: some Scene {
        WindowGroup {
            MainView()
        }
        .modelContainer(Injection.modelContainer)
        .environmentObject(Injection.instance.resolve(GamePresenter.self)!)
        .environmentObject(Injection.instance.resolve(FavoriteListPresenter.self)!)
        .environmentObject(Injection.instance.resolve(SearchPresenter.self)!)
    }
}
