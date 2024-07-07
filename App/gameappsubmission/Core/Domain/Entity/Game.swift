//
//  Game.swift
//  gameappsubmission
//
//  Created by Fauzi Nur Noviansyah on 26/05/24.
//
class Game: Identifiable {
    let id: Int
    let title: String
    let imageUrl: String
    let supportedPlatformLabel: [String]
    let rating: Double
    let esrbRating: String
    let releasedDate: String
    let playtime: String
    let desc: String
    let website: String

    init(id: Int, title: String,
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
