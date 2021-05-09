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
    private var externalSearchResults = [Company]()
    private var internalSearchResults = [Company]()
    private var watchlist = [(company: Company, quotes: CompanyQuotes)]()
    
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
        
        view.backgroundColor = UIColor(rgb: 0xF8F8FA)
        navigationItem.title = "Stock Quotes"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        setupTableView(tableView)
        setupTableView(searchVC.tableView)
        setupDelegation()
    }
    
    // MARK: - Public methods
    func show(companies: [Company]) {
        let searchResults = Set(companies).subtracting(Set(internalSearchResults))
        externalSearchResults = searchResults.sorted()
        searchVC.tableView.reloadSections(IndexSet(0...1), with: .automatic)
    }
    
    func add(company: (Company, CompanyQuotes)) {
        watchlist.append(company)
        tableView.insertRows(at: [IndexPath(row: watchlist.count-1, section: 0)], with: .bottom)
    }

    // MARK: - Private methods
    private func setupTableView(_ tableView: UITableView) {
        tableView.backgroundColor = UIColor(rgb: 0xF8F8FA)
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
        internalSearchResults.removeAll()
        externalSearchResults.removeAll()
        searchVC.tableView.reloadSections(IndexSet(0...1), with: .automatic)
        
        let text = searchText.trimmingCharacters(in: .whitespaces).lowercased()
        guard !text.contains(" "), text.count > 2 else { return }
        
        watchlist.forEach {
            if $0.company.description.lowercased().contains(text) || $0.company.symbol.lowercased().contains(text) {
                internalSearchResults.append($0.company)
            }
        }
        
        viewModel.searchCompany(text)
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
            if section == 0 && !internalSearchResults.isEmpty {
                return "Watchlist"
            } else if section == 1 && !externalSearchResults.isEmpty {
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
            return watchlist.count
        } else {
            return section == 0 ? internalSearchResults.count : externalSearchResults.count
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: StocksTableViewCell.identifier, for: indexPath) as! StocksTableViewCell
        if tableView === self.tableView {
            let company = watchlist[indexPath.row]
            cell.company = "\(company.0.description)(\(company.0.symbol)) - \(company.1.currentPrice)"
        } else {
            let company: Company
            if indexPath.section == 0 {
                company = internalSearchResults[indexPath.row]
            } else {
                company = externalSearchResults[indexPath.row]
            }
            cell.company = "\(company.description) (\(company.symbol))"
        }
        
        return cell
    }
    
    //MARK: - TableView Delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView === searchVC.tableView && indexPath.section == 1 {
            let company = externalSearchResults[indexPath.row]
            let alertVC = UIAlertController(title: "Add \(company.description)?", message: nil, preferredStyle: .alert)
            let action = UIAlertAction(title: "Yes", style: .default) { [unowned self] _ in
                viewModel.fetchQuotes(for: company)
                
                externalSearchResults.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .left)
                
                internalSearchResults.append(company)
                tableView.insertRows(at: [IndexPath(row: internalSearchResults.count-1, section: 0)], with: .left)
            }
            alertVC.addAction(action)
            alertVC.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
            present(alertVC, animated: true)
        }
    }
    
}
