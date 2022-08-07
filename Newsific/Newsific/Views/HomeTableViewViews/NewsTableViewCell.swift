//
//  NewsTableViewCell.swift
//  Newsific
//
//  Created by István Juhász on 2022. 08. 05..
//

import Foundation
import UIKit
import SDWebImage

class NewsTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    
    static let reuseID = "NewsCell"
    static let rowHeight: CGFloat = CGFloat(100.0)
    
    private let newsImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "warship.jpeg")?.withRenderingMode(.alwaysOriginal))
        imageView.contentMode = .scaleToFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 8
        imageView.isSkeletonable = true
        
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Russian warship: Moskva sinks in black sea Russian warship: Moskva sinks in black sea"
        label.numberOfLines = 2
        label.lineBreakMode = .byTruncatingTail
        label.textColor = .label
        label.font = UIFont.preferredFont(forTextStyle: .body, compatibleWith: .none)
        
        return label
    }()
    
    private let authorLabel: UILabel = {
        let label = UILabel()
        label.text = "BBC News"
        label.textColor = .label
        label.font = UIFont.preferredFont(forTextStyle: .subheadline, compatibleWith: .none)
        
        return label
    }()
    
    private let timeLabel: UILabel = {
        let label = UILabel()
        label.text = "4h ago"
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
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helpers
    
    public func configure(imageURL: String, newsTitle: String, author: String, date: String) {
        self.titleLabel.text = newsTitle
        self.authorLabel.text = author
        self.timeLabel.text = date
        
        newsImageView.sd_setImage(with: URL(string: imageURL), completed: nil)
    }
    
    private func configureUI() {
        
        addSubview(newsImageView)
        newsImageView.anchor(top: topAnchor, leading: leadingAnchor, bottom: bottomAnchor, paddingTop: 8, paddingLeading: 8, paddingBottom: 8)
        newsImageView.setDimensions(height: 92, width: 92)
        
        let stack = UIStackView(arrangedSubviews: [authorLabel, clockImage, timeLabel])
        stack.axis = .horizontal
        
        addSubview(stack)
        stack.anchor(leading: newsImageView.trailingAnchor, bottom: bottomAnchor, paddingLeading: 4, paddingBottom: 8)
        stack.setCustomSpacing(20, after: authorLabel)
        stack.setCustomSpacing(5, after: clockImage)
        
        addSubview(titleLabel)
        titleLabel.anchor(leading: newsImageView.trailingAnchor, bottom: stack.topAnchor, trailing: trailingAnchor, paddingLeading: 4, paddingBottom: 4, paddingTrailing: 8)
        titleLabel.centerY(inView: newsImageView)
        
    }
    
}

