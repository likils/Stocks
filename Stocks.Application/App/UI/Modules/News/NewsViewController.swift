// ----------------------------------------------------------------------------
//
//  NewsViewController.swift
//
//  @likils <likils@icloud.com>
//  Copyright (c) 2021. All rights reserved.
//
// ----------------------------------------------------------------------------

import Combine
import CombineCocoa
import StocksData
import StocksNetwork
import StocksSystem
import UIKit

// ----------------------------------------------------------------------------

final class NewsViewController: UITableViewController {
    
    // MARK: - Subviews
    
    private let newsCategoriesView = NewsCategoriesView()

    // MARK: - Private Properties

    private let viewModel: NewsViewModel
    private var news: [NewsCellModel] = .empty
    private var subscriptions: Set<AnyCancellable> = .empty
    
    // MARK: - Construction

    init(viewModel: NewsViewModel) {
        self.viewModel = viewModel

        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Methods

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "Business News"

        setupNewsCategoriesView()
        setupTableView()
        setupSubscriptions()
    }
    
    // MARK: - Actions

    private func reloadNews(with newsModels: [NewsCellModel]) {
        self.tableView.refreshControl?.endRefreshing()
        self.news = newsModels
        self.tableView.reloadSections(IndexSet(integer: 1), with: .automatic)
    }

    private func refresh() {
        let category = self.newsCategoriesView.getCurrentNewsCategory()
        self.viewModel.refreshNews(with: category)
    }
    
    // MARK: - Private Methods

    private func setupNewsCategoriesView() {
        let newsCategories = self.viewModel.getNewsCategories()
        self.newsCategoriesView.updateView(with: newsCategories, listener: self)
    }

    private func setupTableView() {

        self.tableView? <- {
            $0.separatorStyle = .none
            $0.showsVerticalScrollIndicator = false
            $0.contentInset = Const.tableViewInsets
            $0.refreshControl = UIRefreshControl()
            $0.registerCell(NewsCell.self)
        }
    }

    private func setupSubscriptions() {

        self.viewModel
            .getNewsPublisher()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in self?.reloadNews(with: $0) }
            .store(in: &self.subscriptions)

        self.tableView.refreshControl?
            .isRefreshingPublisher
            .sink { [weak self] _ in self?.refresh() }
            .store(in: &self.subscriptions)
    }

    // MARK: - Inner Types

    private enum Const {
        static let tableViewInsets = UIEdgeInsets(top: 0, left: 0, bottom: 16, right: 0)
        static let tableViewHeaderHeight: CGFloat = 44.0
    }
}

// MARK: - @protocol UITableViewDelegate

extension NewsViewController {

    // MARK: - Methods

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let viewModel = self.news[indexPath.row]
        self.viewModel.showNewsArticle(with: viewModel)
    }
}

// MARK: - @protocol UITableViewDataSource

extension NewsViewController {

    // MARK: - Methods
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        2 // header in section 0; content in section 1 - for news categories hiding when scrolling
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        section == 0 ? Const.tableViewHeaderHeight : 0
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        section == 0 ? self.newsCategoriesView : nil
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        section == 0 ? 0 : self.news.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableView.dequeueReusableCell(NewsCell.self, for: indexPath) <- {

            let newsModel = self.news[indexPath.row]
            $0.updateView(with: newsModel)

            let maxImageSize = $0.frame.size.width
            let imagePublisher = self.viewModel.getImagePublisher(withSize: maxImageSize, for: newsModel)
            $0.subscribeToImageChanges(with: imagePublisher)
        }
    }
}

// MARK: - @protocol NewsCategoriesViewListener

extension NewsViewController: NewsCategoriesViewListener {

    // MARK: - Methods

    func newsCategoryDidSelect(_ newsCategory: NewsCategory) {
        self.tableView.refreshControl?.beginRefreshing()
        self.viewModel.refreshNews(with: newsCategory)
    }
}
