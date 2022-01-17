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
import UIKit

// ----------------------------------------------------------------------------

protocol NewsViewOutput: AnyObject {

// MARK: - Methods

    func getNewsCategories() -> [NewsCategory]

    func getNewsPublisher() -> NewsPublisher

    func refreshNews(with category: NewsCategory)

    func requestNewsImage(withSize imageSize: Double, for newsModel: NewsModel) -> ImagePublisher?

    func showNewsArticle(with newsModel: NewsModel)
}

// ----------------------------------------------------------------------------

final class NewsViewController: UITableViewController {
    
// MARK: - Subviews
    
    private let newsCategoriesView = NewsCategoriesView()
    
// MARK: - Dimensions

    static private let tableHeaderHeight: CGFloat = 44
    static private let tableContentInsets = UIEdgeInsets(top: 0, left: 0, bottom: 16, right: 0)
    
// MARK: - Private Properties

    private let viewOutput: NewsViewOutput

    private var news: [NewsModel] = []
    private var newsSubscriber: AnyCancellable?
    private var refreshControlSubscriber: AnyCancellable?
    
// MARK: - Construction

    init(viewOutput: NewsViewOutput) {
        self.viewOutput = viewOutput

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
        setupNewsTableView()
    }
    
// MARK: - Actions

    private func reloadNews(with newsModels: [NewsModel]) {
        self.tableView.refreshControl?.endRefreshing()
        self.news = newsModels
        self.tableView.reloadSections(IndexSet(integer: 1), with: .automatic)
    }

    private func refresh() {
        let category = newsCategoriesView.getCurrentNewsCategory()
        viewOutput.refreshNews(with: category)
    }
    
// MARK: - Private Methods

    private func setupNewsCategoriesView() {
        let newsCategories = viewOutput.getNewsCategories()
        newsCategoriesView.updateView(with: newsCategories, listener: self)
    }

    private func setupNewsTableView() {
        tableView.backgroundColor = .View.backgroundColor
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.contentInset = Self.tableContentInsets
        tableView.refreshControl = UIRefreshControl()
        tableView.register(NewsTableViewCell.self, forCellReuseIdentifier: NewsTableViewCell.identifier)

        self.newsSubscriber = viewOutput
            .getNewsPublisher()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in self?.reloadNews(with: $0) }

        self.refreshControlSubscriber = tableView.refreshControl?
            .isRefreshingPublisher
            .sink { [weak self] _ in self?.refresh() }
    }
}

// ----------------------------------------------------------------------------
// MARK: - TableView Delegate & DataSource

extension NewsViewController {

// MARK: - Methods
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        2 // header in section 0; content in section 1 - for animation and header hiding
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        section == 0 ? Self.tableHeaderHeight : 0
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        section == 0 ? newsCategoriesView : nil
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        section == 0 ? 0 : news.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NewsTableViewCell.identifier, for: indexPath)
        if let cell = cell as? NewsTableViewCell {

            let newsModel = news[indexPath.row]
            cell.setNews(newsModel)

            let maxImageSize = cell.frame.size.width
            let imagePublisher = viewOutput.requestNewsImage(withSize: maxImageSize, for: newsModel)

            cell.subscribeToImageChanges(with: imagePublisher)
        }
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let viewModel = news[indexPath.row]
        viewOutput.showNewsArticle(with: viewModel)
    }
}

// ----------------------------------------------------------------------------
// MARK: - @protocol NewsCategoriesViewListener

extension NewsViewController: NewsCategoriesViewListener {

// MARK: - Methods

    func newsCategoryDidSelect(_ newsCategory: NewsCategory) {
        viewOutput.refreshNews(with: newsCategory)
    }
}
