//
//  GameViewController.swift
//  gameappsubmission
//
//  Created by Fauzi Nur Noviansyah on 10/06/24.
//

import Foundation
import UIKit
import SwiftData
import SwiftUI

@MainActor
class GameViewModel: ObservableObject {
    @Published var gameList: AsyncResult<[Game],Error>
    @Published var searchResult: AsyncResult<[Game],Error>
    @Published var gameDetail: AsyncResult<Game, Error>
    
    let network = NetworkService()
    
    init() {
        self.gameList = .initial
        self.searchResult = .initial
        self.gameDetail = .initial
    }
    
    func setFavoriteState(modelContext: ModelContext, currentValue isSelected: Bool) {
        if !isSelected {
            addGameToFavorite(context: modelContext)
        } else {
            removeGameFromFavorite(context: modelContext)
        }
    }
    
    func getGameDetail(withId id: String) async {
        gameDetail = .loading
        let result = await network.getGameDetail(withId: id)
        gameDetail = result
    }
    
    func resetSearchResult() {
        searchResult = .initial
    }
    
    func getGameList() async {
        gameList = .loading
        let result = await network.getGameList()
        gameList = result
    }
    
    func searchGame(withQuery query: String) {
        searchResult = .loading
        Task {
            let result = await network.getGameList(withQuery: query)
            searchResult = result
        }
    }
    
    func openWebView(url: String) {
        let link = URL(string: url)
        guard let link = link else {return}
        UIApplication.shared.open(link)
    }
    
    func addGameToFavorite(context: ModelContext) {
        if let data = gameDetail.data {
            context.insert(data)
        }
    }
    
    func removeGameFromFavorite(context: ModelContext) {
        do {
            let id = gameDetail.data!.id
            try context.delete(model: Game.self, where: #Predicate {game in
                return game.id == id})
        } catch {
            print("Error occurred while deleting data: \(error)")
        }
    }
}
