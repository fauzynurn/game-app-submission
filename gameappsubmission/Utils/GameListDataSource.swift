//
//  GameViewControllerExtension.swift
//  gameappsubmission
//
//  Created by Fauzi Nur Noviansyah on 02/06/24.
//

import UIKit
import Kingfisher

class GameListDataSource: NSObject, UITableViewDataSource {
    var data: [Game] = []
    
    func updateData(with data: [Game]) {
        self.data = data
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: GameTableViewCell.identifier, for: indexPath) as! GameTableViewCell

        cell.gameName.sizeToFit()
        
        let game = data[indexPath.row]
        let url = URL(string: game.imageUrl)
        cell.gameImage.kf.setImage(with: url)
        
        cell.gameName.text = game.title
        cell.supportedPlatform.text = game.supportedPlatformLabel.joined(separator: " | ")
        cell.rating.text = "\(game.rating)"
        cell.esrbRating.text = game.esrbRating
        cell.releasedDate.text = game.releasedDate
        cell.selectionStyle = .none
        return cell
    }
}
