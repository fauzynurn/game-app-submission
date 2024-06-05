//
//  SearchViewController.swift
//  gameappsubmission
//
//  Created by Fauzi Nur Noviansyah on 02/06/24.
//

import UIKit

class SearchViewController: UIViewController, UISearchBarDelegate {

    @IBOutlet weak var searchTableView: UITableView!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet weak var noResultView: UIStackView!
    
    let searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.placeholder = "Game name"
        return searchController
    }()
    private var searchResultList: [Game] = []
    var dataSource: GameListDataSource = GameListDataSource()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.backButtonDisplayMode = .minimal
        
        dataSource.data = searchResultList
        searchTableView.dataSource = dataSource
        searchTableView.delegate = self
        searchController.searchBar.delegate = self
        navigationItem.searchController = searchController
        searchTableView.separatorStyle = .none
        loadingIndicator.hidesWhenStopped = true
        searchTableView.register(GameTableViewCell.nib(), forCellReuseIdentifier: GameTableViewCell.identifier)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let query = searchBar.text
        guard let query = query else {return}
        searchTableView.isHidden = true
        searchGame(with: query)
    }
    
    func searchGame(with query: String) {
            Task  {
                loadingIndicator.startAnimating()
                noResultView.isHidden = true
                let network = NetworkService()
                do {
                    searchResultList = try await network.getGameList(withQuery: query)
                    loadingIndicator.stopAnimating()
                    dataSource.updateData(with: searchResultList)
                    if searchResultList.isEmpty {
                        noResultView.isHidden = false
                    } else {
                        noResultView.isHidden = true
                        searchTableView.reloadData()
                    }
                } catch {
                    loadingIndicator.stopAnimating()
                }
                searchTableView.isHidden = false
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

extension SearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let gameDetailViewController = storyboard?.instantiateViewController(withIdentifier: "GameDetailViewController") as! GameDetailViewController
        gameDetailViewController.hidesBottomBarWhenPushed = true
        gameDetailViewController.gameId = "\(searchResultList[indexPath.row].id)"
        self.navigationController?.pushViewController(gameDetailViewController, animated: true)
    }
}
