//
//  Main.swift
//  gameappsubmission
//
//  Created by Fauzi Nur Noviansyah on 08/06/24.
//

import SwiftUI
import SwiftData
import Swinject

@main
struct Main: App {
    var body: some Scene {
        WindowGroup {
            MainView()
        }
        .modelContainer(Injection.modelContainer)
        .environmentObject(Injection.instance.resolve(GamePresenter.self)!)
    }
}
