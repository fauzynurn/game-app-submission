//
//  Game.swift
//  Core
//
//  Created by Fauzi Nur Noviansyah on 07/07/24.
//

public class Game: Identifiable {
    public let id: Int
    public let title: String
    public let imageUrl: String
    public let supportedPlatformLabel: [String]
    public let rating: Double
    public let esrbRating: String
    public let releasedDate: String
    public let playtime: String
    public let desc: String
    public let website: String

    public init(id: Int,
                title: String,
                imageUrl: String,
                supportedPlatformLabelList: [String],
                rating: Double,
                esrbRating: String,
                releasedDate: String,
                playtime: String,
                description: String,
                website: String
    ) {
        self.id = id
        self.title = title
        self.imageUrl = imageUrl
        self.supportedPlatformLabel = supportedPlatformLabelList
        self.rating = rating
        self.esrbRating = esrbRating
        self.releasedDate = releasedDate
        self.playtime = playtime
        self.desc = description
        self.website = website
    }

    static func minutesToHoursAndMinutes(_ minutes: Int) -> (hours: Int, leftMinutes: Int) {
        return (minutes / 60, (minutes % 60))
    }
}
