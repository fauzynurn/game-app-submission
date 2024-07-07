//
//  GameModel.swift
//  Core
//
//  Created by Fauzi Nur Noviansyah on 07/07/24.
//

import Foundation
import SwiftData

@Model
public class GameModel: Identifiable {
    @Attribute(.unique) public var id: Int
    public var title: String
    public var imageUrl: String
    public var supportedPlatformLabel: [String]
    public var rating: Double
    public var esrbRating: String
    public var releasedDate: String
    public var playtime: String
    public var desc: String
    public var website: String

    public init(from dictionary: [String: Any]) {
        id = dictionary.getValue(as: Int.self, fromKey: "id")
        title = dictionary.getValue(as: String.self, fromKey: "name")
        imageUrl = dictionary.getValue(as: String.self, fromKey: "background_image")
        let platformList = dictionary.getValue(as: [[String: Any]].self, fromKey: "parent_platforms")
        supportedPlatformLabel = platformList.compactMap {
            let platformItem = $0.getValue(as: [String: Any].self, fromKey: "platform")
            return platformItem.getValue(as: String.self, fromKey: "name")
        }
        let date = dictionary.getValue(as: String.self, fromKey: "released")
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let dateObject = formatter.date(from: date)
        releasedDate = dateObject?.formatted(date: .long, time: .omitted) ?? ""
        let rawPlaytime = dictionary.getValue(as: Int.self, fromKey: "playtime")
        let hourMinuteFormat = GameModel.minutesToHoursAndMinutes(rawPlaytime)
        playtime = hourMinuteFormat.hours != 0 ?
        "\(hourMinuteFormat.hours)h \(hourMinuteFormat.leftMinutes)m" :
        "\(hourMinuteFormat.leftMinutes)m"
        website = dictionary.getValue(as: String.self, fromKey: "website")
        desc = dictionary.getValue(as: String.self, fromKey: "description_raw")
        rating = dictionary.getValue(as: Double.self, fromKey: "rating")
        let esrbRate = dictionary.getValue(as: [String: Any].self, fromKey: "esrb_rating")
        esrbRating = esrbRate.getValue(as: String.self, fromKey: "name")
    }

    public init(id: Int, title: String, imageUrl: String, supportedPlatformLabelList: [String],
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
