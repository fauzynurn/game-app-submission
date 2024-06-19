//
//  GameViewController.swift
//  gameappsubmission
//
//  Created by Fauzi Nur Noviansyah on 10/06/24.
//

import Foundation
import UIKit

@MainActor
class GameViewModel: ObservableObject {
    @Published var gameList: AsyncResult<[Game],Error>
    @Published var searchResult: AsyncResult<[Game],Error>
    @Published var gameDetail: AsyncResult<Game, Error>
    
    @Published var isFavorite: Bool = false
    
    let network = NetworkService()
    
    init() {
        self.gameList = .initial
        self.searchResult = .initial
        self.gameDetail = .initial
    }
    
    func getFavoriteState() {
        if let gameId = gameDetail.data?.id {
            let favoriteList = PreferenceHelper.favoriteGameList
            let isExist = favoriteList.first(where: {$0 == gameId}) != nil
            isFavorite = isExist
        }
    }
    
    func setFavoriteState() {
        if !isFavorite {
            addGameToFavorite(gameId: gameDetail.data!.id)
        } else {
            removeGameFromFavorite(gameId: gameDetail.data!.id)
        }
        isFavorite.toggle()
    }
    
    func getGameDetail(withId id: String) async {
        gameDetail = .loading
        let result = await network.getGameDetail(withId: id)
        gameDetail = result
        getFavoriteState()
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
    
    func addGameToFavorite(gameId: Int) {
        var currentList = PreferenceHelper.favoriteGameList
        currentList.append(gameId)
        PreferenceHelper.favoriteGameList = currentList
    }
    
    func removeGameFromFavorite(gameId: Int) {
        var currentList = PreferenceHelper.favoriteGameList
        let isExist = currentList.first(where: {$0 == gameId}) != nil
        if isExist {
            currentList.removeAll(where: {$0 == gameId})
            PreferenceHelper.favoriteGameList = currentList
        }
    }
}
