//
//  DetailedNewsController.swift
//  Newsific
//
//  Created by István Juhász on 2022. 08. 07..
//

import Foundation
import UIKit
import SDWebImage
import LoremSwiftum

class DetailedNewsController: UIViewController {
    
    // MARK: - Properties
    
    private var data: News
    
    private let textView: UITextView = {
        let textView = UITextView()
        textView.text = Lorem.paragraphs(2...7)
        textView.textColor = .label
        textView.isScrollEnabled = false
        textView.font = UIFont.preferredFont(forTextStyle: .body, compatibleWith: .none)
        
        return textView
    }()
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = .systemBackground
        scrollView.isUserInteractionEnabled = true
        scrollView.isDirectionalLockEnabled = true
        scrollView.setContentOffset(CGPoint(x: 0, y: scrollView.contentOffset.y), animated: true)
        scrollView.showsVerticalScrollIndicator = false
        
        return scrollView
    }()
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "warship.jpeg")?.withRenderingMode(.alwaysOriginal))
        imageView.contentMode = .scaleToFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 8
        
        return imageView
    }()
    
    private lazy var backButton: UIBarButtonItem = {
        let button = UIBarButtonItem(image: UIImage(systemName: "chevron.backward"), style: .done, target: self, action: #selector(dismissSelf))
        button.tintColor = .label
        return button
    }()
    
    private lazy var authorLabel: UILabel = {
        let label = UILabel()
        label.text = data.author
        label.textColor = .label
        label.font = UIFont.preferredFont(forTextStyle: .headline, compatibleWith: .none)
        
        return label
    }()
    
    private lazy var timeLabel: UILabel = {
        let label = UILabel()
        label.text = data.convertedPublished
        label.textColor = .systemGray
        label.font = UIFont.preferredFont(forTextStyle: .callout, compatibleWith: .none)
        
        return label
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = data.title
        label.textColor = .label
        label.numberOfLines = 3
        label.lineBreakMode = .byTruncatingTail
        label.font = UIFont.preferredFont(forTextStyle: .title3, compatibleWith: .none)
        
        return label
    }()
    
    private lazy var categoryLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemGray
        label.font = UIFont.preferredFont(forTextStyle: .callout, compatibleWith: .none)
        
        let joinedString = data.category.joined(separator: ", ").capitalized
        label.text = joinedString
        
        return label
    }()
    
    // MARK: - Lifecycle
    
    init(withData data: News) {
        self.data = data
        
        
        super.init(nibName: nil, bundle: nil)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = backButton
        
        
        configureUI()
    }
    
    // MARK: - Helpers
    
    private func configureUI() {
        view.backgroundColor = .systemBackground
        
        self.imageView.sd_setImage(with: URL(string: data.image))
        
        scrollView.frame = view.bounds
        
        view.addSubview(scrollView)
        scrollView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor, paddingLeading: 8, paddingTrailing: 8)
        
        scrollView.addSubview(authorLabel)
        authorLabel.anchor(top: scrollView.topAnchor, leading: scrollView.leadingAnchor, paddingTop: 8, paddingLeading: 8)
        
        scrollView.addSubview(timeLabel)
        timeLabel.anchor(top: authorLabel.bottomAnchor, leading: scrollView.leadingAnchor, paddingTop: 8, paddingLeading: 8)
        
        scrollView.addSubview(imageView)
        imageView.anchor(top: timeLabel.bottomAnchor, leading: scrollView.leadingAnchor, trailing: scrollView.leadingAnchor, paddingTop: 16, paddingLeading: 8, paddingTrailing: 8)
        imageView.setDimensions(height: 250, width: view.frame.width - 24)
        
        scrollView.addSubview(categoryLabel)
        categoryLabel.anchor(top: imageView.bottomAnchor, leading: scrollView.leadingAnchor, paddingTop: 8, paddingLeading: 8)
        
        scrollView.addSubview(titleLabel)
        titleLabel.anchor(top: categoryLabel.bottomAnchor, leading: scrollView.leadingAnchor, trailing: view.trailingAnchor, paddingTop: 8, paddingLeading: 8, paddingTrailing: 8)
        
        scrollView.addSubview(textView)
        textView.anchor(top: titleLabel.bottomAnchor, leading: scrollView.leadingAnchor, bottom: scrollView.bottomAnchor, trailing: view.trailingAnchor, paddingTop: 8, paddingLeading: 8, paddingTrailing: 8)
    }
    
    // MARK: - Selectors
    
    @objc private func dismissSelf() {
        dismiss(animated: true)
    }
}
