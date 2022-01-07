//
//  NewsCategoryCollectionViewCell.swift
//  Stocks
//
//  Created by likils on 21.05.2021.
//

import UIKit

class NewsCategoryCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Subviews
    private let backView = CellBackgroundView()
    
    private let categoryLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        label.textColor = .Text.secondaryColor
        return label
    }()
    
    // MARK: - Public properties
    override var isSelected: Bool {
        didSet {
            isSelected ? selectCell() : deselectCell()
        }
    }
    
    // MARK: - Construction
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: - Public Methods
    func set(category: NewsCategory) {
        let text: String

        switch category {
            case .general:
                text = "👋🏻General"
            case .forex:
                text = "📈Forex"
            case .crypto:
                text = "💰Crypto"
            case .merger:
                text = "👔Merger"
        }
        
        categoryLabel.text = text
    }
    
    // MARK: - Private Methods
    private func selectCell() {
        categoryLabel.textColor = .white
        
        backView.animationBeginColor = .View.defaultAppColor
        backView.animationEndColor = .View.defaultAppColor
        backView.pressedScale = 1
        backView.animate()
    }
    
    private func deselectCell() {
        categoryLabel.textColor = .Text.secondaryColor
        backView.backgroundColor = .white
    }
    
    private func setupView() {
        contentView.addSubview(backView)
        backView.addSubview(categoryLabel)
        
        NSLayoutConstraint.activate([
            backView.topAnchor.constraint(equalTo: contentView.topAnchor),
            backView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            backView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            backView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            categoryLabel.centerXAnchor.constraint(equalTo: backView.centerXAnchor, constant: -1),
            categoryLabel.centerYAnchor.constraint(equalTo: backView.centerYAnchor)
        ])
    }
    
}
