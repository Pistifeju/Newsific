//
//  HomeTableSectionHeaderView.swift
//  Newsific
//
//  Created by István Juhász on 2022. 08. 05..
//

import Foundation
import UIKit

protocol HomeTableSectionHeaderViewDelegate {
    func didTapTopic(_ topic: String)
}

protocol HomeTableSectionHeaderViewSeeAllDelegate {
    func didTapSeeAll()
}

class HomeTableSectionHeaderView: UIView {
    
    // MARK: - Properties
    
    private var selectedCell: IndexPath = IndexPath.init(row: 0, section: 0)
    
    var delegate: HomeTableSectionHeaderViewDelegate?
    var seeAllDelegate: HomeTableSectionHeaderViewSeeAllDelegate?
    
    private let topics = ["all",
                          "regional",
                          "technology",
                          "lifestyle",
                          "business",
                          "general",
                          "programming",
                          "science",
                          "entertainment",
                          "world",
                          "sports",
                          "finance",
                          "academia",
                          "politics",
                          "health",
                          "opinion",
                          "food",
                          "game"]
    

    
    private let topicsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = CGFloat(35)
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.register(HomeCollectionViewCell.self, forCellWithReuseIdentifier: HomeCollectionViewCell.resueID)
        cv.showsVerticalScrollIndicator = false
        cv.showsHorizontalScrollIndicator = false
        
        return cv
    }()
    
    private lazy var seeAllButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("See All", for: .normal)
        button.setTitleColor(UIColor.systemGray, for: .normal)
        button.addTarget(self, action: #selector(didTapSeeAll), for: .touchUpInside)
        
        return button
    }()
    
    private let latestLabel: UILabel = {
        let label = UILabel()
        label.text = "Latest"
        label.font = UIFont.preferredFont(forTextStyle: .headline, compatibleWith: .none)
        label.textColor = .label
        
        return label
    }()
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        topicsCollectionView.delegate = self
        topicsCollectionView.dataSource = self
        
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helpers
    
    private func configureUI() {
        backgroundColor = .systemBackground
        
        addSubview(latestLabel)
        latestLabel.anchor(top: topAnchor, leading: leadingAnchor,paddingTop: 8, paddingLeading: 8)
        
        addSubview(seeAllButton)
        seeAllButton.anchor(trailing: trailingAnchor, paddingTrailing: 8)
        seeAllButton.centerY(inView: latestLabel)
        
        addSubview(topicsCollectionView)
        topicsCollectionView.anchor(top: latestLabel.bottomAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, paddingTop: 8, paddingLeading: 8, paddingBottom: 8)
        topicsCollectionView.setDimensions(height: 20, width: frame.width)
    }
    
    // MARK: - Selectors
    
    @objc private func didTapSeeAll() {
        print("DEBUG: Did tap see all")
        seeAllDelegate?.didTapSeeAll()
    }
}

extension HomeTableSectionHeaderView: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let previousSelectedCell = collectionView.cellForItem(at: selectedCell) as? HomeCollectionViewCell {
            previousSelectedCell.label.textColor = .systemGray
        }
        
        selectedCell = indexPath
        
        let newSelectedCell = collectionView.cellForItem(at: selectedCell) as! HomeCollectionViewCell
        newSelectedCell.label.textColor = .label
        
        print("DEBUG: Selected item: \(topics[indexPath.row]) at: \(selectedCell)")
        delegate?.didTapTopic(topics[indexPath.row])
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 2, bottom: 0, right: 5)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return topics.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeCollectionViewCell.resueID, for: indexPath) as! HomeCollectionViewCell
        cell.label.text = topics[indexPath.row].capitalized
        cell.label.textColor = .systemGray
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return topics[indexPath.row].size(withAttributes: nil)
    }
}
