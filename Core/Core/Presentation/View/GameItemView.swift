//
//  GameItemView.swift
//  gameappsubmission
//
//  Created by Fauzi Nur Noviansyah on 08/06/24.
//

import SwiftUI

public struct GameItemView: View {
    let imageUrl: String
    let gameName: String
    let supportedPlatformLabel: String
    let ratingLabel: String
    let esrbRatingLabel: String
    let releasedDate: String

    public init(
        imageUrl: String,
        gameName: String,
        supportedPlatformLabel: String,
        ratingLabel: String,
        esrbRatingLabel: String,
        releasedDate: String) {
            self.imageUrl = imageUrl
            self.gameName = gameName
            self.supportedPlatformLabel = supportedPlatformLabel
            self.ratingLabel = ratingLabel
            self.esrbRatingLabel = esrbRatingLabel
            self.releasedDate = releasedDate
        }

    public var body: some View {
        HStack(spacing: 12) {
            AsyncImage(url: URL(string: imageUrl)) { result in
                result.image?.resizable().scaledToFill()
            }.frame(width: 150, height: 100)
                .cornerRadius(8)
            VStack(alignment: .leading, spacing: 4) {
                Text(
                    gameName
                ).font(
                    .system(
                        size: 20,
                        weight: .bold
                    )
                )
                Text(supportedPlatformLabel)
                    .lineLimit(1)
                    .font(.system(size: 15))
                Text(releasedDate).font(.system(size: 15))
                HStack {
                    HStack(spacing: 4) {
                        Image(systemName: "star.fill").foregroundColor(.yellow)
                        Text(ratingLabel).font(.system(size: 15))
                    }
                    Spacer()
                    Text(esrbRatingLabel).font(.system(size: 15))
                }
            }
        }
    }
}

#Preview(
    traits: .sizeThatFitsLayout
) {
    GameItemView(
        imageUrl: "https://media.rawg.io/media/games/20a/20aa03a10cda45239fe22d035c0ebe64.jpg",
        gameName: "Star Wars",
        supportedPlatformLabel: "Windows | Mac",
        ratingLabel: "4.8",
        esrbRatingLabel: "Everyone",
        releasedDate: "21 December 2024"
    )
}
