//
//  HomeController.swift
//  Newsific
//
//  Created by István Juhász on 2022. 08. 04..
//

import Foundation
import UIKit

class HomeController: UIViewController {
    
    // MARK: - Properties
    
    private lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshNews), for: .valueChanged)
        refreshControl.tintColor = .label
        refreshControl.attributedTitle = NSAttributedString(string: "Refreshing...")

        return refreshControl
    }()
    
    private var tableHeaderView = HomeControllerTableHeaderView()
    private var sectionHeaderView = HomeTableSectionHeaderView()
    
    private var firstNew: News = News(id: "", title: "", author: "", image: "", category: [], published: "")
    private var news: APIResponse = APIResponse(news: [News]())
    private var filteredNews: APIResponse = APIResponse(news: [News]())
    private var selectedTopic: String = "All"
    
    private var emptyCategory: Bool {
        return filteredNews.news.count == 0
    }
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .systemBackground
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
        tableView.sectionHeaderTopPadding = 0
        
        return tableView
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(NewsTableViewCell.self, forCellReuseIdentifier: NewsTableViewCell.reuseID)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "emptyCell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.refreshControl = refreshControl
        
        sectionHeaderView.delegate = self
        sectionHeaderView.seeAllDelegate = self
        
        fetchNews()
        
        configureUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
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
                    strongSelf.firstNew = strongSelf.news.news.remove(at: 0)
                    strongSelf.filteredNews = strongSelf.news
                    strongSelf.setupTableHeaderView(with: strongSelf.firstNew)
                    strongSelf.tableView.reloadData()
                    strongSelf.refreshControl.endRefreshing()
                    print("DEBUG: count: \(strongSelf.news.news.count)")
                }
            case .failure(let error):
                print("DEBUG: Error occurred with error: \(error.localizedDescription)")
            }
        }
    }
    
    private func setupTableHeaderView(with news: News) {
        tableHeaderView.configure(imageURL: news.image, newsTitle: news.title, author: news.author, date: news.published)
    }
    
    private func configureUI() {
        view.backgroundColor = .systemBackground
        navigationItem.title = "Newsific"
        
        view.addSubview(tableView)
        tableView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor, paddingLeading: 8, paddingTrailing: 8)
        tableView.center(inView: view)
        
        tableView.tableHeaderView = tableHeaderView
        tableView.tableHeaderView?.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 400)
    }
    
    // MARK: - Selectors
    
    @objc private func refreshNews() {
        fetchNews()
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension HomeController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = sectionHeaderView
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return NewsTableViewCell.rowHeight
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if emptyCategory {
            return 1
        }
    
        return filteredNews.news.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if emptyCategory {
            let cell = tableView.dequeueReusableCell(withIdentifier: "emptyCell", for: indexPath)
            cell.textLabel?.text = "Currently there aren't any news for the \(selectedTopic.capitalized) category."
            cell.textLabel?.numberOfLines = 0
            cell.textLabel?.textAlignment = .center
            tableView.separatorStyle = .none
            cell.textLabel?.textColor = .label
            cell.backgroundColor = .systemBackground
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: NewsTableViewCell.reuseID, for: indexPath) as! NewsTableViewCell
        let newsAtIndex = filteredNews.news[indexPath.row]
        
        cell.configure(imageURL: newsAtIndex.image, newsTitle: newsAtIndex.title, author: newsAtIndex.author, date: newsAtIndex.published)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if emptyCategory {
            tableView.deselectRow(at: indexPath, animated: true)
            return
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
        let cell = tableView.cellForRow(at: indexPath) as! NewsTableViewCell
    }
    
}

extension HomeController: HomeTableSectionHeaderViewSeeAllDelegate {
    func didTapSeeAll() {
        let vc = SeeAllController()
        let nav = UINavigationController(rootViewController: vc)
        nav.modalPresentationStyle = .fullScreen
        nav.title = "See All"
        nav.navigationBar.tintColor = .label
        nav.navigationBar.barTintColor = .systemBackground
        nav.navigationBar.backgroundColor = .systemBackground
        
        //present(nav, animated: true)
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: - HomeTableSectionHeaderViewDelegate

extension HomeController: HomeTableSectionHeaderViewDelegate {
    func didTapTopic(_ topic: String) {
        selectedTopic = topic
        if selectedTopic == "all" {
            filteredNews = news
        } else {
            filteredNews.news.removeAll()
            for item in news.news {
                for category in item.category {
                    if category == topic {
                        filteredNews.news.append(item)
                    }
                }
            }
        }
        
        tableView.reloadData()
    }
}
