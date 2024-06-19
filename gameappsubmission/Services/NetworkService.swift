//
//  NetworkService.swift
//  gameappsubmission
//
//  Created by Fauzi Nur Noviansyah on 26/05/24.
//

import Foundation
import SystemConfiguration

class NetworkService {
    let baseUrl = "https://api.rawg.io"
    let apiKey = "3309dae54f6348feb342ca16d0a83c70"
    
    func getGameList(withQuery query: String? = nil) async -> AsyncResult<[Game], Error> {
        do {
            let url = "\(baseUrl)/api/games"
            var components = URLComponents(string: url)
            components?.queryItems = [
                URLQueryItem(name: "key", value: apiKey),
                URLQueryItem(name: "page_size", value: "10"),
                URLQueryItem(name: "search", value: query)
            ]
            guard let url = components?.url else {
                return .failure(NSError())
            }
            let request = URLRequest(url: url)
            
            let (data, response) = try await URLSession.shared.data(for: request)
            
            if let dictionary = try JSONSerialization.jsonObject(with: data) as? [String:Any] {
                if let results = dictionary["results"] as? [[String:Any]] {
                    let gameList = results.map {
                        return Game(from: $0)
                    }
                    return .success(gameList)
                }
            }
            return .success([Game]())
        } catch {
            print("ERROR: \(error)")
            return .failure(error)
        }
    }
    
    func getGameDetail(withId id: String) async -> AsyncResult<Game, Error> {
        do {
            var components = URLComponents(string: "\(baseUrl)/api/games/\(id)")
            components?.queryItems = [
                URLQueryItem(name: "key", value: apiKey)
            ]
            guard let url = components?.url else {
                return .failure(NSError())
            }
            let request = URLRequest(url: url)
            
            let (data, _) = try await URLSession.shared.data(for: request)
            
            if let object = try JSONSerialization.jsonObject(with: data) as? [String:Any] {
                return .success(Game(from: object))
            }
            return .failure(NSError())
        } catch {
            print("ERROR: \(error)")
            return .failure(error)
        }
    }
    
}
