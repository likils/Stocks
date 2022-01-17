// ----------------------------------------------------------------------------
//
//  NewsCategoriesView.swift
//
//  @likils <likils@icloud.com>
//  Copyright (c) 2022. All rights reserved.
//
// ----------------------------------------------------------------------------

import UIKit

// ----------------------------------------------------------------------------

protocol NewsCategoriesViewListener: AnyObject {

// MARK: - Methods

    func newsCategoryDidSelect(_ newsCategory: NewsCategory)
}

// ----------------------------------------------------------------------------

final class NewsCategoriesView: UIView {

// MARK: - Outlets

    private let collectionView: UICollectionView = {

        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal

        return UICollectionView(frame: CGRect.zero, collectionViewLayout: flowLayout)
    }()

// MARK: - Construction

    init() {
        super.init(frame: CGRect.zero)

        setupCollectionView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

// MARK: - Private Properties

    private var newsCategories: [NewsCategory] = []
    private var currentNewsCategoryIndex = 0
    private weak var listener: NewsCategoriesViewListener?

// MARK: - Methods

    func updateView(with newsCategories: [NewsCategory], listener: NewsCategoriesViewListener?) {

        self.newsCategories = newsCategories
        self.listener = listener

        self.collectionView.reloadData()

        let indexPath = IndexPath(item: 0, section: 0)
        self.collectionView.selectItem(at: indexPath, animated: false, scrollPosition: .centeredHorizontally)
    }

    func getCurrentNewsCategory() -> NewsCategory {
        return newsCategories[currentNewsCategoryIndex]
    }

// MARK: - Private Methods

    private func setupCollectionView() {

        self.collectionView <- { cv in
            cv.delegate = self
            cv.dataSource = self

            cv.backgroundColor = .clear
            cv.showsHorizontalScrollIndicator = false
            cv.contentInset = CollectionViewSize.contentInset
            cv.registerCell(NewsCategoryCollectionViewCell.self)
        }

        addSubview(self.collectionView)
        self.collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.height.equalTo(CollectionViewSize.height)
        }
    }

// MARK: - Dimensions

    private enum CollectionViewSize {
        static let height: CGFloat = 44.0
        static let cellHeight: CGFloat = 34.0
        static let cellSpacing: CGFloat = 12.0
        static let contentInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
    }
}

// ----------------------------------------------------------------------------
// MARK: - @protocol UICollectionViewDataSource

extension NewsCategoriesView: UICollectionViewDataSource {

// MARK: - Methods

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        newsCategories.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(NewsCategoryCollectionViewCell.self, for: indexPath)

        let category = newsCategories[indexPath.item]
        cell.updateView(with: category)

        return cell
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

        currentNewsCategoryIndex = indexPath.item

        let newsCategory = newsCategories[currentNewsCategoryIndex]
        listener?.newsCategoryDidSelect(newsCategory)
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

        let category = newsCategories[indexPath.row]
        let width = getCellWidthForCategory(category)
        let height = CollectionViewSize.cellHeight

        return CGSize(width: width, height: height)
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumInteritemSpacingForSectionAt section: Int
    ) -> CGFloat {

        CollectionViewSize.cellSpacing
    }

    private func getCellWidthForCategory(_ category: NewsCategory) -> CGFloat {
        let cellWidth: CGFloat

        switch category {
            case .general:
                cellWidth = 94

            case .forex:
                cellWidth = 80
                
            case .crypto:
                cellWidth = 86

            case .merger:
                cellWidth = 90
        }

        return cellWidth
    }
}
