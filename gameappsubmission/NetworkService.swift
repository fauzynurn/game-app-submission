//
//  NetworkService.swift
//  gameappsubmission
//
//  Created by Fauzi Nur Noviansyah on 26/05/24.
//

import Foundation

class NetworkService {
    let baseUrl = "https://api.rawg.io"
    let apiKey = "3309dae54f6348feb342ca16d0a83c70"
    
    func getGameList(withQuery query: String? = nil) async throws -> [Game] {
        var components = URLComponents(string: "\(baseUrl)/api/games")
        components?.queryItems = [
            URLQueryItem(name: "key", value: apiKey),
            URLQueryItem(name: "page_size", value: "10"),
            URLQueryItem(name: "search", value: query),
            URLQueryItem(name: "search_exact", value: "true")
        ]
        guard let url = components?.url else {
            fatalError("ERROR: URL is null")
        }
        let request = URLRequest(url: url)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            fatalError("ERROR: fail to fetch data \(response)")
        }
        
        if let dictionary = try JSONSerialization.jsonObject(with: data) as? [String:Any] {
            if let results = dictionary["results"] as? [[String:Any]] {
                let gameList = results.map {
                    return Game(from: $0)
                }
                return gameList
            }
        }
        return []
    }
    
    func getGameDetail(withId id: String) async throws -> Game {
        var components = URLComponents(string: "\(baseUrl)/api/games/\(id)")
        components?.queryItems = [
            URLQueryItem(name: "key", value: apiKey)
        ]
        guard let url = components?.url else {
            fatalError("ERROR: URL is null")
        }
        let request = URLRequest(url: url)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            fatalError("ERROR: fail to fetch data \(response)")
        }
        
        if let object = try JSONSerialization.jsonObject(with: data) as? [String:Any] {
            return Game(from: object)
        } else {
            fatalError("ERROR: the response cannot be parsed")
        }
    }
    
}
