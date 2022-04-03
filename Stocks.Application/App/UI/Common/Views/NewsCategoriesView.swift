// ----------------------------------------------------------------------------
//
//  NewsCategoriesView.swift
//
//  @likils <likils@icloud.com>
//  Copyright (c) 2022. All rights reserved.
//
// ----------------------------------------------------------------------------

import StocksData
import StocksSystem
import UIKit

// ----------------------------------------------------------------------------

protocol NewsCategoriesViewListener: AnyObject {

// MARK: - Methods

    func newsCategoryDidSelect(_ newsCategory: NewsCategory)
}

// ----------------------------------------------------------------------------

final class NewsCategoriesView: UIView {

// MARK: - Subviews

    private let collectionView: UICollectionView = {

        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal

        return UICollectionView(frame: CGRect.zero, collectionViewLayout: flowLayout)
    }()

// MARK: - Private Properties

    private var newsCategories: [NewsCategory] = .empty
    private var currentNewsCategoryIndex = 0
    private weak var listener: NewsCategoriesViewListener?

// MARK: - Construction

    init() {
        super.init(frame: CGRect.zero)

        setupCollectionView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

// MARK: - Methods

    func updateView(with newsCategories: [NewsCategory], listener: NewsCategoriesViewListener?) {

        self.newsCategories = newsCategories
        self.listener = listener

        self.collectionView.reloadData()

        let indexPath = IndexPath(item: 0, section: 0)
        self.collectionView.selectItem(at: indexPath, animated: false, scrollPosition: .centeredHorizontally)
    }

    func getCurrentNewsCategory() -> NewsCategory {
        return self.newsCategories[currentNewsCategoryIndex]
    }

// MARK: - Private Methods

    private func setupCollectionView() {

        self.collectionView <- {
            $0.delegate = self
            $0.dataSource = self

            $0.backgroundColor = .clear
            $0.showsHorizontalScrollIndicator = false
            $0.contentInset = CollectionViewSize.contentInset
            $0.registerCell(NewsCategoryCollectionViewCell.self)
        }

        addSubview(self.collectionView)
        self.collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.height.equalTo(CollectionViewSize.height)
        }
    }

// MARK: - Inner Types

    private enum CollectionViewSize {
        static let height: CGFloat = 44.0
        static let cellHeight: CGFloat = 34.0
        static let contentInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        static let interitemSpacing: CGFloat = 12.0
    }
}

// ----------------------------------------------------------------------------
// MARK: - @protocol UICollectionViewDataSource

extension NewsCategoriesView: UICollectionViewDataSource {

// MARK: - Methods

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        self.newsCategories.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(NewsCategoryCollectionViewCell.self, for: indexPath)

        let category = self.newsCategories[indexPath.item]
        cell?.updateView(with: category)

        return cell ?? UICollectionViewCell()
    }
}

// ----------------------------------------------------------------------------
// MARK: - @protocol UICollectionViewDelegate

extension NewsCategoriesView: UICollectionViewDelegate {

// MARK: - Methods

    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return (collectionView.cellForItem(at: indexPath)?.isSelected == false)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)

        self.currentNewsCategoryIndex = indexPath.item

        let newsCategory = self.newsCategories[currentNewsCategoryIndex]
        self.listener?.newsCategoryDidSelect(newsCategory)
    }
}

// ----------------------------------------------------------------------------
// MARK: - @protocol UICollectionViewDelegateFlowLayout

extension NewsCategoriesView: UICollectionViewDelegateFlowLayout {

// MARK: - Methods

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {

        let category = self.newsCategories[indexPath.row]
        let width = getCellWidthForCategory(category)
        let height = CollectionViewSize.cellHeight

        return CGSize(width: width, height: height)
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumInteritemSpacingForSectionAt section: Int
    ) -> CGFloat {

        CollectionViewSize.interitemSpacing
    }

    private func getCellWidthForCategory(_ category: NewsCategory) -> CGFloat {
        let cellWidth: CGFloat

        switch category {
            case .general:
                cellWidth = 94.0

            case .forex:
                cellWidth = 80.0
                
            case .crypto:
                cellWidth = 86.0

            case .merger:
                cellWidth = 90.0
        }

        return cellWidth
    }
}
