// ----------------------------------------------------------------------------
//
//  NewsVM.swift
//
//  @likils <likils@icloud.com>
//  Copyright (c) 2021. All rights reserved.
//
// ----------------------------------------------------------------------------

import Combine
import UIKit

// ----------------------------------------------------------------------------

final class NewsVC: UITableViewController, NewsView {
    
    // MARK: - Subviews
    private let collectionOfCategories: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        
        let cv = UICollectionView(frame: CGRect.zero, collectionViewLayout: flowLayout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.backgroundColor = .View.backgroundColor.withAlphaComponent(0.97)
        cv.showsHorizontalScrollIndicator = false
        cv.contentInset = NewsVC.collectionContentInsets
        cv.heightAnchor.constraint(equalToConstant: NewsVC.tableHeaderHeight).isActive = true
        cv.register(NewsCategoryCollectionViewCell.self, forCellWithReuseIdentifier: NewsCategoryCollectionViewCell.identifier)
        return cv
    }()
    
    private lazy var tableHeaderView: UIView = {
        let view = UIView()
        view.addSubview(collectionOfCategories)
        NSLayoutConstraint.activate([
            collectionOfCategories.topAnchor.constraint(equalTo: view.topAnchor),
            collectionOfCategories.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionOfCategories.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionOfCategories.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        return view
    }()
    
    // MARK: - Dimensions
    static private let tableHeaderHeight: CGFloat = 44
    static private let collectionCellSpacing: CGFloat = 12
    static private let collectionCellHeight: CGFloat = 34
    static private let inset: CGFloat = 16
    static private let tableContentInsets = UIEdgeInsets(top: 0, left: 0, bottom: inset, right: 0)
    static private let collectionContentInsets = UIEdgeInsets(top: 0, left: inset, bottom: 0, right: inset)
    
    // MARK: - Private properties
    private let viewModel: NewsViewModel
    private var news: [NewsModel] {
        viewModel.news
    }
    private var categories: [NewsCategory] {
        viewModel.newsCategories
    }
    
    // MARK: - Construction
    init(viewModel: NewsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        viewModel.view = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Business News"
        
        collectionOfCategories.delegate = self
        collectionOfCategories.dataSource = self
        collectionOfCategories.selectItem(at: IndexPath(item: 0, section: 0), animated: false, scrollPosition: .centeredHorizontally)
        
        setupTableView()
        refresh()
    }
    
    // MARK: - Actions
    @objc func refresh() {
        guard let index = collectionOfCategories.indexPathsForSelectedItems?.first?.row else { return }
        let category = categories[index]
        viewModel.updateNews(with: category)
    }
    
    // MARK: - Public Methods
    func reloadNews(if isUpdated: Bool) {
        tableView.refreshControl?.endRefreshing()
        if isUpdated {
            tableView.reloadSections(IndexSet(integer: 1), with: .automatic)
        }
    }
    
    // MARK: - Private Methods
    private func setupTableView() {
        tableView.backgroundColor = .View.backgroundColor
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.contentInset = Self.tableContentInsets
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.addTarget(self, action: #selector(refresh), for: .valueChanged)
        tableView.register(NewsTableViewCell.self, forCellReuseIdentifier: NewsTableViewCell.identifier)
    }
    
}

// MARK: - TableView Delegate & DataSource
extension NewsVC {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        2 // header in section 0; content in section 1 - for animation and header hiding
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        section == 0 ? Self.tableHeaderHeight : 0
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        section == 0 ? tableHeaderView : nil
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        section == 0 ? 0 : news.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NewsTableViewCell.identifier, for: indexPath)
        if let cell = cell as? NewsTableViewCell {

            let news = news[indexPath.row]
            cell.setNews(news)

            let maxImageSize = Double(cell.frame.size.width)
            let publisher = viewModel.requestNewsImage(withSize: maxImageSize, for: indexPath)

            cell.subscribeToImageChanges(with: publisher)
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        guard let cell = tableView.cellForRow(at: indexPath) as? NewsTableViewCell else { return nil }
        cell.animate { [weak self] in
            self?.viewModel.cellTapped(at: indexPath.row)
        }
        return indexPath
    }
    
}

// MARK: - CollectionView Delegate & DataSource
extension NewsVC: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NewsCategoryCollectionViewCell.identifier, for: indexPath)
        if let cell = cell as? NewsCategoryCollectionViewCell {
            let category = categories[indexPath.item]
            cell.set(category: category)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        guard let cell = collectionView.cellForItem(at: indexPath), !cell.isSelected else { return false }
        return true
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        refresh()
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }
    
}

// MARK: - CollectionView DelegateFlowLayout
extension NewsVC: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let category = categories[indexPath.row]
        let width = cellWidthForCategory(category)
        let height = Self.collectionCellHeight
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        Self.collectionCellSpacing
    }

    private func cellWidthForCategory(_ category: NewsCategory) -> CGFloat {
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
