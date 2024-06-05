//
//  GameDetailViewController.swift
//  gameappsubmission
//
//  Created by Fauzi Nur Noviansyah on 30/05/24.
//

import UIKit

class GameDetailViewController: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var gameImage: UIImageView!
    @IBOutlet weak var supportedPlatform: UILabel!
    @IBOutlet weak var gameName: UILabel!
    @IBOutlet weak var releasedDate: UILabel!
    @IBOutlet weak var duration: UILabel!
    @IBOutlet weak var rating: UILabel!
    @IBOutlet weak var visitWebsiteButton: UIButton!
    @IBOutlet weak var gameDescription: UILabel!
    
    var gameId: String = ""
    
    private var game: Game? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.delegate = self
        navigationController?.navigationBar.tintColor = .white
        loadingIndicator.hidesWhenStopped = true
        Task  {
            scrollView.isHidden = true
            loadingIndicator.startAnimating()
            let network = NetworkService()
            do {
                game = try await network.getGameDetail(withId: gameId)
                scrollView.isHidden = false
                bindGameData()
                loadingIndicator.stopAnimating()
            } catch {
                loadingIndicator.stopAnimating()
            }
        }
    }
    
    @IBAction func onTapVisitWebsiteButton(_ sender: Any) {
        guard let website = game?.website, !website.isEmpty else {return}
        openBrowser(withUrl: website)
    }
    
    func openBrowser(withUrl url: String) {
        let link = URL(string: url)
        guard let link = link else {return}
        UIApplication.shared.open(link)
    }
    
    func bindGameData() {
        guard let gameData = game else {return}
        
        let url = URL(string: gameData.imageUrl)
        gameImage.kf.setImage(with: url)
        supportedPlatform.text = gameData.supportedPlatformLabel.joined(separator: " | ")
        gameName.text = gameData.title
        releasedDate.text = "Released on \(gameData.releasedDate)"
        duration.text = gameData.playtime
        rating.text = "\(gameData.rating)"
        gameDescription.text = gameData.description
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let verticalOffset = scrollView.contentOffset.y
        if verticalOffset >= 104 {
            navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
            navigationController?.navigationBar.shadowImage = nil
        } else {
            navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
            navigationController?.navigationBar.shadowImage = UIImage()
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
