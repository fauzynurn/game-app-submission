//
//  PreferenceHelper.swift
//  gameappsubmission
//
//  Created by Fauzi Nur Noviansyah on 19/06/24.
//

import Foundation

struct PreferenceHelper {
    static let favoriteGameListKey = "favorite_list"
    
    static var favoriteGameList: [Int] {
        get {
            return UserDefaults.standard.array(forKey: favoriteGameListKey) as? [Int] ?? []
        }
        set {
            UserDefaults.standard.set(newValue, forKey: favoriteGameListKey)
        }
    }
}
