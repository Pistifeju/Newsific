//
//  HomeController.swift
//  Newsific
//
//  Created by István Juhász on 2022. 08. 04..
//

import Foundation
import UIKit
import SkeletonView

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
    
    
    private var didFinishFetch = false
    private var firstNew: News = News(id: "", title: "", author: "", image: "", category: [], published: "")
    private var news: APIResponse = APIResponse(news: [News]())
    private var filteredNews: APIResponse = APIResponse(news: [News]())
    private var selectedTopic: String = "All"
    
    private var emptyCategory: Bool {
        return filteredNews.news.count == 0
    }
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .systemBackground
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
        tableView.sectionHeaderTopPadding = 0
        
        return tableView
    }()
    
    private let trendingLabel: UILabel = {
        let label = UILabel()
        label.text = "Trending"
        label.font = UIFont.preferredFont(forTextStyle: .headline, compatibleWith: .none)
        label.textColor = .label
        
        return label
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(NewsTableViewCell.self, forCellReuseIdentifier: NewsTableViewCell.reuseID)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "emptyCell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.refreshControl = refreshControl
        
        tableHeaderView.isSkeletonable = true
        tableHeaderView.delegate = self

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
        tableHeaderView.showAnimatedSkeleton()
        
        
        APICaller.shared.fetchNews { [weak self] result in
            guard let strongSelf = self else {
                return
            }
            
            switch result {
            case .success(let news):
                DispatchQueue.main.async {
                    strongSelf.didFinishFetch = true
                    strongSelf.news.news = news.news
                    strongSelf.firstNew = strongSelf.news.news.remove(at: 0)
                    strongSelf.filteredNews = strongSelf.news
                    strongSelf.tableHeaderView.hideSkeleton()
                    strongSelf.setupTableHeaderView(with: strongSelf.firstNew)
                    strongSelf.tableView.reloadData()
                    strongSelf.refreshControl.endRefreshing()
                }
            case .failure(let error):
                print("DEBUG: Error occurred with error: \(error.localizedDescription)")
            }
        }
    }
    
    private func setupTableHeaderView(with news: News) {
        tableHeaderView.configure(withData: news)
    }
    
    private func configureUI() {
        view.backgroundColor = .systemBackground
        navigationItem.title = "Newsific"
        
        view.addSubview(trendingLabel)
        trendingLabel.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, paddingLeading: 16)
        
        view.addSubview(tableView)
        tableView.anchor(top: trendingLabel.bottomAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor, paddingLeading: 8, paddingTrailing: 8)
        
        tableView.tableHeaderView = tableHeaderView
        tableView.tableHeaderView?.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 400)
    }
    
    // MARK: - Selectors
    
    @objc private func refreshNews() {
        didFinishFetch = false
        fetchNews()
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension HomeController: UITableViewDelegate, UITableViewDataSource, SkeletonTableViewDataSource {
    
    func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return NewsTableViewCell.reuseID
    }
    
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
            
            if didFinishFetch {
                cell.textLabel?.text = "There isn't any news in the \(selectedTopic.capitalized) category."
            } else {
                cell.textLabel?.text = "Loading News"
            }
            
            cell.textLabel?.numberOfLines = 0
            cell.textLabel?.textAlignment = .center
            tableView.separatorStyle = .none
            cell.textLabel?.textColor = .label
            cell.backgroundColor = .systemBackground
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: NewsTableViewCell.reuseID, for: indexPath) as! NewsTableViewCell
        
        let newsAtIndex = filteredNews.news[indexPath.row]
        
        cell.configure(imageURL: newsAtIndex.image, newsTitle: newsAtIndex.title, author: newsAtIndex.author, date: newsAtIndex.convertedPublished)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if emptyCategory {
            tableView.deselectRow(at: indexPath, animated: false)
            return
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        let vc = DetailedNewsController(withData: filteredNews.news[indexPath.row])
        let nav = UINavigationController(rootViewController: vc)
        nav.modalPresentationStyle = .fullScreen
        
        present(nav, animated: true)
    }
    
}

// MARK: - HomeTableSectionHeaderViewSeeAllDelegate

extension HomeController: HomeTableSectionHeaderViewSeeAllDelegate {
    func didTapSeeAll() {
        let vc = SeeAllController()
        
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

// MARK: - HomeControllerTableHeaderViewDelegate

extension HomeController: HomeControllerTableHeaderViewDelegate {
    func didTapHeader(_ sender: HomeControllerTableHeaderView) {
        let vc = DetailedNewsController(withData: sender.data)
        let nav = UINavigationController(rootViewController: vc)
        nav.modalPresentationStyle = .fullScreen
        
        present(nav, animated: true)
    }
}
