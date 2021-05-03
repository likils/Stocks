//
//  StocksVC.swift
//  Stocks
//
//  Created by likils on 01.05.2021.
//

import UIKit

class StocksVC: UIViewController, StocksView {
    
    // MARK: - Subviews
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = UIColor(rgb: 0xF8F8FA)
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = true
        tableView.register(StocksTableViewCell.self, forCellReuseIdentifier: StocksTableViewCell.identifier)
        return tableView
    }()
    
    // MARK: - Private properties
    private let viewModel: StocksViewModel
    private var stocks = [(Company, CompanyQuotes)]()
    
    // MARK: - Init
    init(viewModel: StocksViewModel) {
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
        setupControllers()
    }
    
    // MARK: - Public methods
    func showSearchResult(with info: [(Company, CompanyQuotes)]) {
        stocks = info
        tableView.reloadSections(IndexSet(integer: 0), with: .top)
    }

    // MARK: - Private methods
    private func setupView() {
        view.backgroundColor = UIColor(rgb: 0xF8F8FA)
        navigationItem.title = "Stock Quotes"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
    
    private func setupControllers() {
        navigationItem.searchController = UISearchController()
        navigationItem.searchController?.searchBar.delegate = self
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
}

extension StocksVC: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if !stocks.isEmpty {
            stocks.removeAll()
            tableView.reloadSections(IndexSet(integer: 0), with: .top)
        }
        
        let text = searchText.trimmingCharacters(in: .whitespaces)
        guard !text.contains(" "), text.count > 3 else { return }
        
        viewModel.searchCompany(text)
    }
    
}

extension StocksVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        stocks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: StocksTableViewCell.identifier, for: indexPath) as! StocksTableViewCell
        let company = stocks[indexPath.row]
        cell.company = "\(company.0.description)(\(company.0.symbol)) - \(company.1.currentPrice)"
        return cell
    }
    
}
