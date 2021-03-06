// ----------------------------------------------------------------------------
//
//  NewsCategoryCell.swift
//
//  @likils <likils@icloud.com>
//  Copyright (c) 2021. All rights reserved.
//
// ----------------------------------------------------------------------------

import StocksData
import StocksSystem
import UIKit

// ----------------------------------------------------------------------------

final class NewsCategoryCell: UICollectionViewCell {

    // MARK: - Subviews

    private let defaultBackgroundView = UIView() <- {
        $0.backgroundColor = StocksColor.background
        $0.layer.cornerRadius = 16.0
    }

    private let categoryLabel = UILabel() <- {
        $0.font = StocksFont.body
        $0.textColor = StocksColor.secondary
        $0.textAlignment = .center
    }

    // MARK: - Properties

    override var isSelected: Bool {
        didSet {
            changeCellColors(isSelected)
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

    // MARK: - Methods

    func updateView(with category: NewsCategory) {
        self.categoryLabel.text = category.text
    }
    
    // MARK: - Private Methods

    private func changeCellColors(_ isSelected: Bool) {
        self.categoryLabel.textColor = isSelected ? .white : StocksColor.secondary
        self.defaultBackgroundView.backgroundColor = isSelected ? StocksColor.brand : StocksColor.background
    }

    private func setupView() {
        contentView.addSubview(defaultBackgroundView)
        defaultBackgroundView.addSubview(categoryLabel)

        setupConstraints()
    }

    private func setupConstraints() {
        defaultBackgroundView.snp.makeConstraints { $0.edges.equalToSuperview() }
        categoryLabel.snp.makeConstraints { $0.edges.equalToSuperview() }
    }
}
