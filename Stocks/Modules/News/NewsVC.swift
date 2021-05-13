//
//  NewsVC.swift
//  Stocks
//
//  Created by likils on 26.04.2021.
//

import UIKit

class NewsVC: UIViewController, NewsView {
    
    // MARK: - Subviews
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .View.backgroundColor
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.register(NewsTableViewCell.self, forCellReuseIdentifier: NewsTableViewCell.identifier)
        return tableView
    }()
    
    // MARK: - Private properties
    private let viewModel: NewsViewModel

    // MARK: - Init
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
        tableView.delegate = self
        tableView.dataSource = self
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.addTarget(self, action: #selector(refresh), for: .valueChanged)
        
        setupView()
        viewModel.getNews()
    }
    
    // MARK: - Actions
    @objc func refresh() {
        viewModel.getNews()
    }
    
    // MARK: - Public methods
    func reloadNews(if isUpdated: Bool) {
        tableView.refreshControl?.endRefreshing()
        if isUpdated {
            tableView.reloadData()
        }
    }
    
    func showImage(_ image: UIImage, at indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? NewsTableViewCell else { return }
        cell.setImage(image)
    }
    
    // MARK: - Private methods
    private func setupView() {
        view.backgroundColor = .View.backgroundColor
        navigationItem.title = "Business News"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
}

// MARK: - TableView Delegate & DataSource
extension NewsVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.news.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NewsTableViewCell.identifier, for: indexPath)
        if let cell = cell as? NewsTableViewCell {
            let news = viewModel.news[indexPath.row]
            cell.news = news
            viewModel.fetchImage(from: news.imageUrl, for: indexPath)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        guard let cell = tableView.cellForRow(at: indexPath) as? NewsTableViewCell else { return nil }
        cell.animate { [weak self] in
            self?.viewModel.cellTapped(with: cell.news?.sourceUrl)
        }
        
        return indexPath
    }
}
