//
//  GameRemoteDataSource.swift
//  Core
//
//  Created by Fauzi Nur Noviansyah on 07/07/24.
//

import Foundation
import SystemConfiguration
import Combine

public protocol GameRemoteDataSourceProtocol {
    func getGameList(withQuery query: String) -> AnyPublisher<[GameModel], Error>

    func getGameDetail(withId id: String) -> AnyPublisher<GameModel, Error>
}

public class GameRemoteDataSourceImpl: GameRemoteDataSourceProtocol {
    public init() {}

    let baseUrl = "https://api.rawg.io"

    private var apiKey: String {
            guard let filePath = Bundle.main.path(forResource: "Rawg-info", ofType: "plist") else {
                fatalError("Couldn't find file 'Rawg-Info.plist'.")
            }
            let plist = NSDictionary(contentsOfFile: filePath)
            guard let value = plist?.object(forKey: "API_KEY") as? String else {
                fatalError("Couldn't find key 'API_KEY' in 'Rawg-Info.plist'.")
            }
            return value
    }

    public func getGameList(withQuery query: String) -> AnyPublisher<[GameModel], Error> {
        return Future<[GameModel], Error> { completion in
            let url = "\(self.baseUrl)/api/games"
            var components = URLComponents(string: url)
            components?.queryItems = [
                URLQueryItem(name: "key", value: self.apiKey),
                URLQueryItem(name: "page_size", value: "10"),
                URLQueryItem(name: "search", value: query)
            ]
            guard let url = components?.url else {
                let error = NSError(domain: "", code: 0)
                completion(.failure(error))
                return
            }
            let request = URLRequest(url: url)

            URLSession.shared.dataTask(with: request) { (data, _, error) in
                if let error = error {
                    print("ERROR: \(error)")
                    let error = NSError(domain: "", code: 0)
                    completion(.failure(error))
                    return
                }
                if let result = data {
                    do {
                        if let object = try JSONSerialization.jsonObject(with: result) as? [String: Any] {
                            if let results = object["results"] as? [[String: Any]] {
                                let gameList = results.map {
                                    return GameModel(from: $0)
                                }
                                return completion(.success(gameList))
                            } else {
                                let error = NSError(domain: "", code: 0)
                                completion(.failure(error))
                            }
                        }
                    } catch {
                        let error = NSError(domain: "", code: 0)
                        completion(.failure(error))
                    }
                    return completion(.success([GameModel]()))
                } else {
                    let error = NSError(domain: "", code: 0)
                    completion(.failure(error))
                }
            }.resume()
        }.eraseToAnyPublisher()
    }

    public func getGameDetail(withId id: String) -> AnyPublisher<GameModel, Error> {
        return Future<GameModel, Error> { completion in
            var components = URLComponents(string: "\(self.baseUrl)/api/games/\(id)")
            components?.queryItems = [
                URLQueryItem(name: "key", value: self.apiKey)
            ]
            guard let url = components?.url else {
                let error = NSError(domain: "", code: 0)
                return completion(.failure(error))
            }
            let request = URLRequest(url: url)

            URLSession.shared.dataTask(with: request) { (data, _, error) in
                if let error = error {
                    print("ERROR: \(error)")
                    let error = NSError(domain: "", code: 0)
                    completion(.failure(error))
                    return
                }
                if let result = data {

                    do {
                        if let dictionary = try JSONSerialization.jsonObject(with: result) as? [String: Any] {
                            return completion(.success(GameModel(from: dictionary)))
                        }
                    } catch {
                        let error = NSError(domain: "", code: 0)
                        completion(.failure(error))
                    }
                    return completion(.success(GameModel(from: [String: Any]())))
                } else {
                    let error = NSError(domain: "", code: 0)
                    completion(.failure(error))
                }
            }.resume()
        }.eraseToAnyPublisher()
    }

}
