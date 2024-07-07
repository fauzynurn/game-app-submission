//
//  GameMapper+Ext.swift
//  Core
//
//  Created by Fauzi Nur Noviansyah on 07/07/24.
//

extension GameModel {
    func toEntity() -> Game {
        return Game(
            id: self.id,
            title: self.title,
            imageUrl: self.imageUrl,
            supportedPlatformLabelList: self.supportedPlatformLabel,
            rating: self.rating,
            esrbRating: self.esrbRating,
            releasedDate: self.releasedDate,
            playtime: self.playtime,
            description: self.desc,
            website: self.website
        )
    }
}

extension Game {
    func toModel() -> GameModel {
        return GameModel(
            id: self.id,
            title: self.title,
            imageUrl: self.imageUrl,
            supportedPlatformLabelList: self.supportedPlatformLabel,
            rating: self.rating,
            esrbRating: self.esrbRating,
            releasedDate: self.releasedDate,
            playtime: self.playtime,
            description: self.desc,
            website: self.website)
    }
}

extension Array where Element == GameModel {
    func toEntities() -> [Game] {
        return self.map {
            $0.toEntity()
        }
    }
}
