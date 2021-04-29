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
        tableView.backgroundColor = UIColor(rgb: 0xF8F8FA)
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.register(NewsTableViewCell.self, forCellReuseIdentifier: NewsTableViewCell.identifier)
        return tableView
    }()
    
    //MARK: - Public properties
    var news = [News]()
    
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
        
        setupView()
        viewModel.getNews()
    }
    
    // MARK: - Public methods
    func showNews(_ news: [News]) {
        self.news = news
        tableView.reloadData()
    }
    
    func showImage(_ image: UIImage, at indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? NewsTableViewCell else { return }
        cell.image = image
    }
    
    // MARK: - Private methods
    private func setupView() {
        view.backgroundColor = UIColor(rgb: 0xF8F8FA)
        navigationItem.title = "Business News"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor)
        ])
    }
    
}

// MARK: - TableView Delegate & DataSource
extension NewsVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        news.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NewsTableViewCell.identifier, for: indexPath)
        if let cell = cell as? NewsTableViewCell {
            let news = news[indexPath.row]
            
            cell.date = news.date
            cell.headLine = news.headline
            cell.id = news.id
            cell.sourceUrl = news.sourceUrl
            cell.source = news.source
            cell.summary = news.summary
            
            cell.image = UIImage() // reset old cell picture
            viewModel.fetchImage(from: news.imageUrl, for: indexPath)
        }
        return cell
    }
    
}
