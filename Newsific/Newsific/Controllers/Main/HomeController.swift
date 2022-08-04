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
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
    }
    
    // MARK: - Helpers
    
    private func configureUI() {
        view.backgroundColor = .red
    }
    
    // MARK: - Selectors
    
}
