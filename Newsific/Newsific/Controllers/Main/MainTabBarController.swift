//
//  MainTabBarController.swift
//  Newsific
//
//  Created by István Juhász on 2022. 08. 04..
//

import Foundation
import UIKit

class MainTabBarController: UITabBarController {
    
    // MARK: - Properties
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
    }
    
    // MARK: - Helpers
    
    private func setupTabBar() {
        tabBar.tintColor = .systemBlue
        tabBar.isTranslucent = false
        
        let home = HomeController()
        let explore = ExploreController()
        let bookmark = BookmarkController()
        
        let homeNav = UINavigationController(rootViewController: home)
        let exploreNav = UINavigationController(rootViewController: explore)
        let bookmarkNav = UINavigationController(rootViewController: bookmark)
        
        homeNav.tabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName: "house"), selectedImage: UIImage(systemName: "house.fill"))
        exploreNav.tabBarItem = UITabBarItem(title: "Explore", image: UIImage(systemName: "safari"), selectedImage: UIImage(systemName: "safari.fill"))
        bookmarkNav.tabBarItem = UITabBarItem(title: "Bookmark", image: UIImage(systemName: "bookmark"), selectedImage: UIImage(systemName: "bookmark.fill"))
        
        setViewControllers([homeNav, exploreNav, bookmarkNav], animated: true)
    }
    
    private func configureUI() {
        view.backgroundColor = .white
        
        
        setupTabBar()
    }
    
    // MARK: - Selectors
    
}
