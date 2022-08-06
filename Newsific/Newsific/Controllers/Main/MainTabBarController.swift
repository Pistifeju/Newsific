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
        
        setupTabBar()
    }
    
    // MARK: - Helpers
    
    private func setupTabBar() {
        tabBar.tintColor = .label
        tabBar.isTranslucent = false
        tabBar.backgroundColor = .systemBackground
        tabBar.barTintColor = .systemBackground
        
        let home = HomeController()
        let explore = ExploreController()
        let bookmark = BookmarkController()
        
        let homeNav = templateNavigationController(title: "Home", unselectedImage: "house", selectedImage: "house.fill", rootViewController: home)
        let exploreNav = templateNavigationController(title: "Explore", unselectedImage: "safari", selectedImage: "safari.fill", rootViewController: explore)
        let bookmarkNav = templateNavigationController(title: "Bookmark", unselectedImage: "bookmark", selectedImage: "bookmark.fill", rootViewController: bookmark)
        
        setViewControllers([homeNav, exploreNav, bookmarkNav], animated: true)
    }
    
    private func templateNavigationController(title: String, unselectedImage: String, selectedImage: String, rootViewController: UIViewController) -> UINavigationController {
        let nav = UINavigationController(rootViewController: rootViewController)
        nav.tabBarItem = UITabBarItem(title: title, image: UIImage(systemName: unselectedImage), selectedImage: UIImage(systemName: selectedImage))
        nav.navigationBar.barTintColor = .systemBackground
        nav.navigationBar.isHidden = true
        return nav
    }
    
    // MARK: - Selectors
    
}
