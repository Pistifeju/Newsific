//
//  SeeAllController.swift
//  Newsific
//
//  Created by István Juhász on 2022. 08. 06..
//

import Foundation
import UIKit

class SeeAllController: UIViewController {
    
    // MARK: - Properties
    
    private var news: APIResponse = APIResponse(news: [News]())
    private var filteredNews: APIResponse = APIResponse(news: [News]())
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .systemBackground
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
        tableView.sectionHeaderTopPadding = 0
        
        return tableView
    }()
    
    private let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
    
        let rightButton = UIButton()
        rightButton.setImage(UIImage(systemName: "x.circle"), for: .normal)
        rightButton.tintColor = .black
    
        searchBar.searchTextField.rightView = rightButton
        searchBar.searchTextField.rightViewMode = .unlessEditing
        searchBar.placeholder = "Search"
        searchBar.searchBarStyle = .default
        searchBar.searchTextField.leftView?.tintColor = UIColor.label
        searchBar.searchTextField.backgroundColor = .systemGray5
    
        return searchBar
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(NewsTableViewCell.self, forCellReuseIdentifier: NewsTableViewCell.reuseID)
        tableView.delegate = self
        tableView.dataSource = self
        
        searchBar.delegate = self
        
        fetchNews()
        
        configureUI()
    }
    
    // MARK: - Helpers
    
    private func fetchNews() {
        APICaller.shared.fetchNews { [weak self] result in
            guard let strongSelf = self else {
                return
            }
            switch result {
            case .success(let news):
                DispatchQueue.main.async {
                    strongSelf.news.news = news.news
                    strongSelf.filteredNews = strongSelf.news
                    strongSelf.tableView.reloadData()
                    print("DEBUG: count: \(strongSelf.news.news.count)")
                }
            case .failure(let error):
                print("DEBUG: Error occurred with error: \(error.localizedDescription)")
            }
        }
    }
    
    private func configureUI() {
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.barTintColor = .systemBackground
        navigationController?.navigationBar.tintColor = .label
        
        view.addSubview(tableView)
        tableView.frame = view.bounds
    }
    
    // MARK: - Selectors

}

extension SeeAllController: UISearchBarDelegate {
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        print("DEBUG: \(searchBar.text)")
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension SeeAllController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = searchBar
        
        return headerView
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredNews.news.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NewsTableViewCell.reuseID, for: indexPath) as! NewsTableViewCell
        let newsAtIndex = filteredNews.news[indexPath.row]
        
        cell.configure(imageURL: newsAtIndex.image, newsTitle: newsAtIndex.title, author: newsAtIndex.author, date: newsAtIndex.published)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let cell = tableView.cellForRow(at: indexPath) as! NewsTableViewCell
    }
    
}