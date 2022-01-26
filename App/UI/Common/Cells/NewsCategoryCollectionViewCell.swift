// ----------------------------------------------------------------------------
//
//  NewsCategoryCollectionViewCell.swift
//
//  @likils <likils@icloud.com>
//  Copyright (c) 2021. All rights reserved.
//
// ----------------------------------------------------------------------------

import UIKit

// ----------------------------------------------------------------------------

final class NewsCategoryCollectionViewCell: UICollectionViewCell {

// MARK: - Subviews

    private let defaultBackgroundView = DefaultBackgroundView()

    private let categoryLabel = UILabel() <- {
        $0.font = Font.body
        $0.textColor = Color.secondary
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
        let text: String

        switch category {
            case .crypto:
                text = "💰Crypto"

            case .forex:
                text = "📈Forex"

            case .general:
                text = "👋🏻General"

            case .merger:
                text = "👔Merger"
        }

        categoryLabel.text = text
    }

// MARK: - Private Methods

    private func changeCellColors(_ isSelected: Bool) {
        categoryLabel.textColor = isSelected ? .white : Color.secondary
        defaultBackgroundView.backgroundColor = isSelected ? Color.brand : .white
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
