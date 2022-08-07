//
//  HomeControllerTableHeaderView.swift
//  Newsific
//
//  Created by István Juhász on 2022. 08. 04..
//

import Foundation
import UIKit
import SkeletonView

protocol HomeControllerTableHeaderViewDelegate {
    func didTapHeader(_ sender: HomeControllerTableHeaderView)
}

class HomeControllerTableHeaderView: UIView {
    
    // MARK: - Properties
    
    private let tapGestureRecognizer = UITapGestureRecognizer()
    public var data: News = News(id: "", title: "", author: "", image: "", category: [], published: "")
    
    var delegate: HomeControllerTableHeaderViewDelegate?
    
    private let imageView: UIImageView = {
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
        label.numberOfLines = 1
        label.lineBreakMode = .byTruncatingTail
        label.textColor = .label
        label.font = UIFont.preferredFont(forTextStyle: .title3, compatibleWith: .none)
        label.isSkeletonable = true
        
        return label
    }()
    
    private let authorLabel: UILabel = {
        let label = UILabel()
        label.text = "BBC News"
        label.textColor = .label
        label.font = UIFont.preferredFont(forTextStyle: .subheadline, compatibleWith: .none)
        label.isSkeletonable = true
        
        return label
    }()
    
    private let timeLabel: UILabel = {
        let label = UILabel()
        label.text = "4h ago"
        label.textColor = .systemGray
        label.font = UIFont.preferredFont(forTextStyle: .footnote, compatibleWith: .none)
        label.isSkeletonable = true
        
        return label
    }()
    
    private let clockImage: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "clock"))
        imageView.tintColor = .systemGray
        imageView.setDimensions(height: 15, width: 15)
        imageView.isSkeletonable = true
        
        return imageView
    }()
    
    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        isSkeletonable = true
        addGestureRecognizer(tapGestureRecognizer)
        tapGestureRecognizer.addTarget(self, action: #selector(didTapHeader))
        
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helpers
    
    private func configureUI() {
        backgroundColor = .systemBackground
        //backgroundColor = .red
        
        let stack = UIStackView(arrangedSubviews: [authorLabel, clockImage, timeLabel])
        stack.axis = .horizontal
        stack.isSkeletonable = true
        
        addSubview(stack)
        stack.anchor(leading: leadingAnchor, bottom: bottomAnchor, paddingLeading: 8, paddingBottom: 8)
        stack.setCustomSpacing(20, after: authorLabel)
        stack.setCustomSpacing(5, after: clockImage)
        
        addSubview(titleLabel)
        titleLabel.anchor(leading: leadingAnchor, bottom: stack.topAnchor, trailing: trailingAnchor, paddingLeading: 8, paddingBottom: 8, paddingTrailing: 8)
        
        addSubview(imageView)
        imageView.anchor(top: topAnchor, leading: leadingAnchor, bottom: titleLabel.topAnchor, trailing: trailingAnchor, paddingTop: 8, paddingLeading: 8, paddingBottom: 8, paddingTrailing: 8)
    }
    
    public func configure(withData data: News) {
        self.data = data
        
        self.titleLabel.text = self.data.title
        self.authorLabel.text = self.data.author
        self.timeLabel.text = self.data.convertedPublished
        
        imageView.sd_setImage(with: URL(string: self.data.image), completed: nil)
    }
    
    // MARK: - Selectors
    
    @objc private func didTapHeader() {
        delegate?.didTapHeader(self)
    }
}
