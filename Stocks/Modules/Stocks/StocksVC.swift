//
//  StocksVC.swift
//  Stocks
//
//  Created by likils on 01.05.2021.
//

import UIKit

class StocksVC: UITableViewController, StocksView {
    
    // MARK: - Subviews
    private let searchVC: UITableViewController
    
    // MARK: - Private properties
    private let viewModel: StocksViewModel
    private weak var refreshTimer: Timer?
    
    // MARK: - Init
    init(viewModel: StocksViewModel) {
        self.viewModel = viewModel
        searchVC = UITableViewController()
        super.init(nibName: nil, bundle: nil)
        viewModel.view = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .View.backgroundColor
        navigationItem.title = "Stock Quotes"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.addTarget(self, action: #selector(refresh), for: .valueChanged)
        
        setupTableView(tableView)
        setupTableView(searchVC.tableView)
        setupDelegation()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        refresh()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        refreshTimer?.invalidate()
    }
    
    // MARK: - Actions
    @objc func refresh() {
        refreshTimer?.invalidate()
        refreshTimer = Timer.scheduledTimer(timeInterval: 15, target: self, selector: #selector(refresh), userInfo: nil, repeats: false)
        refreshTimer?.tolerance = 1
        
        if !viewModel.watchlist.isEmpty {
            viewModel.updateQuotes()
        } else {
            tableView.refreshControl?.endRefreshing()
        }
    }
    
    // MARK: - Public methods
    func updateSearchlist() {
        searchVC.tableView.reloadSections(IndexSet(0...1), with: .automatic)
    }
    
    func updateWatchlist(at indexPath: IndexPath, with action: Action) {
        switch action {
            case .insert:
                tableView.insertRows(at: [indexPath], with: .bottom)
            case .delete:
                tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    func updateQuotes(_ quotes: CompanyQuotes, at indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? StocksTableViewCell else { return }
        cell.companyQuotes = quotes
        
        tableView.refreshControl?.endRefreshing()
    }

    // MARK: - Private methods
    private func setupTableView(_ tableView: UITableView) {
        tableView.backgroundColor = .View.backgroundColor
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = true
        tableView.register(StocksTableViewCell.self, forCellReuseIdentifier: StocksTableViewCell.identifier)
    }
    
    private func setupDelegation() {
        searchVC.tableView.delegate = self
        searchVC.tableView.dataSource = self
        
        let searchController = UISearchController(searchResultsController: searchVC)
        navigationItem.searchController = searchController
        searchController.searchBar.delegate = self
    }
    
}

// MARK: - SearchBar Delegate
extension StocksVC: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.searchCompany(with: searchText)
    }
    
}

extension StocksVC {
    
    // MARK: - TableView Datasource
    override func numberOfSections(in tableView: UITableView) -> Int {
        if tableView === searchVC.tableView {
            return 2
        } else {
            return 1
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if tableView === searchVC.tableView {
            if section == 0 && !viewModel.internalSearchResults.isEmpty {
                return "Watchlist"
            } else if section == 1 && !viewModel.externalSearchResults.isEmpty {
                return "Symbols"
            } else {
                return nil
            }
        } else {
            return nil
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView === self.tableView {
            return viewModel.watchlist.count
        } else {
            return section == 0 ? viewModel.internalSearchResults.count : viewModel.externalSearchResults.count
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: StocksTableViewCell.identifier, for: indexPath)
        
        if let cell = cell as? StocksTableViewCell {
            if tableView === self.tableView {
                let company = viewModel.watchlist[indexPath.row]
                cell.company = company
                viewModel.fetchQuotes(for: company, at: indexPath)
            } else {
                let company: Company
                if indexPath.section == 0 {
                    company = viewModel.internalSearchResults[indexPath.row]
                } else {
                    company = viewModel.externalSearchResults[indexPath.row]
                }
                cell.company = company
            }
        } 
        
        return cell
    }
    
    //MARK: - TableView Delegate
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        guard let cell = tableView.cellForRow(at: indexPath) as? StocksTableViewCell else { return nil }
        cell.animate(completion: nil)
        return indexPath
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView === searchVC.tableView && indexPath.section == 1 {
            let company = viewModel.externalSearchResults[indexPath.row]
            let alertVC = UIAlertController(title: "Add \(company.description)?", message: nil, preferredStyle: .alert)
            let action = UIAlertAction(title: "Yes", style: .default) { [unowned self] _ in
                viewModel.updateWatchlist(at: indexPath.row, with: .insert)
                
                tableView.performBatchUpdates { 
                    tableView.deleteRows(at: [indexPath], with: .left)
                    tableView.insertRows(at: [IndexPath(row: viewModel.internalSearchResults.count-1, section: 0)], with: .left)
                }
            }
            alertVC.addAction(action)
            alertVC.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
            present(alertVC, animated: true)
        }
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        tableView === searchVC.tableView ? false : true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            viewModel.updateWatchlist(at: indexPath.row, with: .delete)
        }
    }
    
}
