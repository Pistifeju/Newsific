//
//  HomeCollectionViewCell.swift
//  Newsific
//
//  Created by István Juhász on 2022. 08. 05..
//

import Foundation
import UIKit

class HomeCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    static let resueID = "HomeCollectionViewCell"
    static let itemSize: CGSize = CGSize(width: 100, height: 20)
    
    
    public let label: UILabel = {
        let label = UILabel()
        label.text = "Science"
        label.textColor = .systemGray
        label.font = UIFont.preferredFont(forTextStyle: .callout, compatibleWith: .none)
        return label
    }()
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helpers
    
    private func configureUI() {
        backgroundColor = .systemBackground
        
        addSubview(label)
        label.center(inView: self)
    }
    
    // MARK: - Selectors
    
}
