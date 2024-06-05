//
//  GameTableViewCell.swift
//  gameappsubmission
//
//  Created by Fauzi Nur Noviansyah on 26/05/24.
//

import UIKit

class GameTableViewCell: UITableViewCell {
    
    @IBOutlet weak var gameName: UILabel!
    @IBOutlet weak var gameImage: UIImageView!
    @IBOutlet weak var supportedPlatform: UILabel!
    @IBOutlet weak var rating: UILabel!
    @IBOutlet weak var esrbRating: UILabel!
    
    static let identifier = "GameTableViewCell"
    
    static func nib() -> UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
