//
//  NewsVC.swift
//  Stocks
//
//  Created by likils on 26.04.2021.
//

import UIKit

class NewsVC: UIViewController, NewsView {
    
    // MARK: - Subviews
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        return tableView
    }()
    
    //MARK: - Public properties
    var news = [News]()
    
    // MARK: - Private properties
    private let viewModel: NewsViewModel
    private let cellIdentifier = "NewsCell"

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
        setupView()
        
        viewModel.getNews()
    }
    
    // MARK: - Public methods
    func showNews(_ news: [News]) {
        self.news = news
        tableView.reloadData()
    }
    
    // MARK: - Private methods
    private func setupView() {
        view.backgroundColor = UIColor(rgb: 0xF8F8FA)
        navigationItem.title = "Business News"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(NewsTableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        tableView.backgroundColor = UIColor(rgb: 0xF8F8FA)
        tableView.separatorStyle = .none
        
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor)
        ])
    }
}

extension NewsVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        news.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let news = news[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! NewsTableViewCell
        cell.date = news.date
        cell.headLine = news.headline
        cell.id = news.id
        cell.imageUrl = news.imageUrl
        cell.redirectUrl = news.url
        cell.source = news.source
        cell.summary = news.summary
        return cell
    }
    
}
