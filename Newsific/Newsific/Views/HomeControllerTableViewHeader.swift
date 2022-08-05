//
//  HomeControllerTableHeaderView.swift
//  Newsific
//
//  Created by István Juhász on 2022. 08. 04..
//

import Foundation
import UIKit

class HomeControllerTableHeaderView: UIView {
    
    // MARK: - Properties
    
    private let trendingLabel: UILabel = {
        let label = UILabel()
        label.text = "Trending"
        label.font = UIFont.preferredFont(forTextStyle: .headline, compatibleWith: .none)
        label.textColor = .label
        
        return label
    }()
    
//    private let latestLabel: UILabel = {
//        let label = UILabel()
//        label.text = "Latest"
//        label.font = UIFont.preferredFont(forTextStyle: .headline, compatibleWith: .none)
//        label.textColor = .systemBackground
//
//        return label
//    }()
//
//    private let seeAllLabel: UILabel = {
//        let label = UILabel()
//        label.text = "See All"
//        label.textColor = .systemGray
//        label.font = UIFont.preferredFont(forTextStyle: .footnote, compatibleWith: .none)
//
//        return label
//    }()
    
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
    
    private let imageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "warship.jpeg")?.withRenderingMode(.alwaysOriginal))
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 8
        
        
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Russian warship: Moskva sinks in black sea Russian warship: Moskva sinks in black sea"
        label.numberOfLines = 1
        label.lineBreakMode = .byTruncatingTail
        label.textColor = .label
        label.font = UIFont.preferredFont(forTextStyle: .title3, compatibleWith: .none)
        
        return label
    }()
    
    private let authorLabel: UILabel = {
        let label = UILabel()
        label.text = "BBC News"
        label.numberOfLines = 2
        label.lineBreakMode = .byWordWrapping
        label.textColor = .label
        label.font = UIFont.preferredFont(forTextStyle: .subheadline, compatibleWith: .none)
        
        return label
    }()
    
    private let timeLabel: UILabel = {
        let label = UILabel()
        label.text = "4h ago"
        label.numberOfLines = 2
        label.lineBreakMode = .byWordWrapping
        label.textColor = .systemGray
        label.font = UIFont.preferredFont(forTextStyle: .footnote, compatibleWith: .none)
        
        return label
    }()
    
    private let clockImage: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "clock"))
        imageView.tintColor = .systemGray
        imageView.setDimensions(height: 15, width: 15)
        
        return imageView
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
        //backgroundColor = .red
        
        addSubview(searchBar)
        searchBar.anchor(top: topAnchor, leading: leadingAnchor, trailing: trailingAnchor)
        
        addSubview(trendingLabel)
        trendingLabel.anchor(top: searchBar.bottomAnchor, leading: leadingAnchor, paddingLeading: 8)
        
        let stack = UIStackView(arrangedSubviews: [authorLabel, clockImage, timeLabel])
        stack.axis = .horizontal
        
        addSubview(stack)
        stack.anchor(leading: leadingAnchor, bottom: bottomAnchor, paddingLeading: 8, paddingBottom: 8)
        stack.setCustomSpacing(20, after: authorLabel)
        stack.setCustomSpacing(5, after: clockImage)
        
        addSubview(titleLabel)
        titleLabel.anchor(leading: leadingAnchor, bottom: stack.topAnchor, trailing: trailingAnchor, paddingLeading: 8, paddingBottom: 8, paddingTrailing: 8)
        
        addSubview(imageView)
        imageView.anchor(top: trendingLabel.bottomAnchor, leading: leadingAnchor, bottom: titleLabel.topAnchor, trailing: trailingAnchor, paddingTop: 8, paddingLeading: 8, paddingBottom: 8, paddingTrailing: 8)
    }
    
    // MARK: - Selectors
    
}
