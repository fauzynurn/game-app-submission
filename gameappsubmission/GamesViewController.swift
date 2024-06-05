//
//  GamesViewController.swift
//  gameappsubmission
//
//  Created by Fauzi Nur Noviansyah on 25/05/24.
//

import UIKit
import Kingfisher

class GamesViewController: UIViewController {
    
    @IBOutlet weak var gameTableView: UITableView!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet weak var errorSection: UIStackView!
    
    private var gameList: [Game] = []
    var dataSource: GameListDataSource = GameListDataSource()
//    var dataSource: GameListDataSource? {
//        didSet {
//            self.gameTableView.dataSource = dataSource
//            self.gameTableView.reloadData()
//        }
//    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.backButtonDisplayMode = .minimal
        dataSource.data = gameList
        gameTableView.dataSource = dataSource
        gameTableView.delegate = self
        gameTableView.separatorStyle = .none
        loadingIndicator.hidesWhenStopped = true
        gameTableView.register(GameTableViewCell.nib(), forCellReuseIdentifier: GameTableViewCell.identifier)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if gameList.isEmpty {
            Task  {
                loadingIndicator.startAnimating()
                let network = NetworkService()
                do {
                    gameList = try await network.getGameList()
                    loadingIndicator.stopAnimating()
                    dataSource.updateData(with: gameList)
                    gameTableView.reloadData()
                } catch {
                    loadingIndicator.stopAnimating()
                    errorSection.isHidden = false
                }
            }
        }
    }
}

extension GamesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let gameDetailViewController = storyboard?.instantiateViewController(withIdentifier: "GameDetailViewController") as! GameDetailViewController
        gameDetailViewController.hidesBottomBarWhenPushed = true
        gameDetailViewController.gameId = "\(gameList[indexPath.row].id)"
        self.navigationController?.pushViewController(gameDetailViewController, animated: true)
    }
}
