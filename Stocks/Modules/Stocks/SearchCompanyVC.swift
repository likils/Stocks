//
//  SearchCompanyVC.swift
//  Stocks
//
//  Created by likils on 19.05.2021.
//

import UIKit

class SearchCompanyVC: UITableViewController, SearchCompanyView {
    
    // MARK: - Dimensions
    static private let tableHeaderHeight: CGFloat = 16
    static private let inset: CGFloat = 16

    // MARK: - Private properties
    private let viewModel: SearchCompanyViewModel
    private weak var delaySearchTimer: Timer?

    // MARK: - Init
    init(viewModel: SearchCompanyViewModel) {
        self.viewModel = viewModel
        super.init(style: .insetGrouped)
        viewModel.searchView = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
    }

    // MARK: - Public methods
    func updateSearchlist() {
        tableView.reloadSections(IndexSet(0...1), with: .fade)
    }
    
    // MARK: - Private methods
    private func setupTableView() {
        tableView.backgroundColor = .View.backgroundColor
        tableView.contentInset = UIEdgeInsets(top: -Self.inset, left: 0, bottom: -Self.inset, right: 0)
        tableView.separatorInset = UIEdgeInsets(top: 0, left: Self.inset, bottom: 0, right: Self.inset)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: UITableViewCell.identifier)
    }
    
}

// MARK: - SearchBar Delegate
extension SearchCompanyVC: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        delaySearchTimer?.invalidate()
        delaySearchTimer = Timer.scheduledTimer(withTimeInterval: 0.3, repeats: false) { [weak self] _ in
            self?.viewModel.searchCompany(with: searchText)
        }
        delaySearchTimer?.tolerance = 0.3
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        viewModel.searchCompany(with: "")
        delaySearchTimer?.invalidate()
    }
    
}

// MARK: - TableView Delegate & Datasource
extension SearchCompanyVC {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        2
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        Self.tableHeaderHeight
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        section == 0 ? viewModel.internalSearchResults.count : viewModel.externalSearchResults.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 && !viewModel.internalSearchResults.isEmpty {
            return "Watchlist"
        } else if section == 1 && !viewModel.externalSearchResults.isEmpty {
            return "Symbols"
        } else {
            return nil
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: UITableViewCell.identifier, for: indexPath)
        cell.textLabel?.numberOfLines = 2
        
        let company: Company
        if indexPath.section == 0 {
            company = viewModel.internalSearchResults[indexPath.row]
        } else {
            company = viewModel.externalSearchResults[indexPath.row]
        }
        
        let symbol = NSMutableAttributedString(string: company.symbol,
                                               attributes: [.font: UIFont.systemFont(ofSize: 16)])
        
        let description = NSAttributedString(string: "\n\(company.description.capitalized)",
                                             attributes: [.foregroundColor: UIColor.gray,
                                                          .font: UIFont.systemFont(ofSize: 14)])
        symbol.append(description)
        
        cell.textLabel?.attributedText = symbol
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            let company = self.viewModel.externalSearchResults[indexPath.row]
            let alertVC = UIAlertController(title: "Add to Watchlist?", message: "\"\(company.description.capitalized)\"", preferredStyle: .alert)
            let action = UIAlertAction(title: "Yes", style: .default) { _ in
                self.viewModel.updateSearchList(at: indexPath.row)
                
                tableView.performBatchUpdates { 
                    tableView.deleteRows(at: [indexPath], with: .left)
                    tableView.insertRows(at: [IndexPath(row: self.viewModel.internalSearchResults.count-1, section: 0)], with: .left)
                }
                tableView.deselectRow(at: indexPath, animated: true)
            }
            alertVC.addAction(action)
            alertVC.addAction(UIAlertAction(title: "No", style: .cancel, handler: { _ in
                tableView.deselectRow(at: indexPath, animated: true)
                
            }))
            self.present(alertVC, animated: true)
        } else {
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
    
}
