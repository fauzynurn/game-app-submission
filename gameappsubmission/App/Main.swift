//
//  Main.swift
//  gameappsubmission
//
//  Created by Fauzi Nur Noviansyah on 08/06/24.
//

import SwiftUI
import SwiftData

@main
struct Main: App {
    var body: some Scene {
        WindowGroup {
            MainView()
        }.modelContainer(for: [
            Game.self
        ])
    }
}
