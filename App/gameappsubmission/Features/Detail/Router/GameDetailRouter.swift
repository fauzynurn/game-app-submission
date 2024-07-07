//
//  GameListRouter.swift
//  gameappsubmission
//
//  Created by Fauzi Nur Noviansyah on 25/06/24.
//

import Foundation
import SwiftUI

class GameDetailRouter {
    func makeGameDetailView(gameId: String) -> some View {
        let presenter = Injection.instance.resolve(GameDetailPresenter.self)!
        return GameDetailView(presenter: presenter, gameId: gameId)
    }
}
