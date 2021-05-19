//
//  StocksVC.swift
//  Stocks
//
//  Created by likils on 01.05.2021.
//

import UIKit

class StocksVC: UITableViewController, StocksView {
    
    // MARK: - Private properties
    private let viewModel: StocksViewModel
    private weak var refreshTimer: Timer?
    
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
        
        navigationItem.title = "Stock Quotes"
        
        setupTableView()
        setupSearchController()
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
    func updateWatchlist(at index: Int, with action: Action) {
        let indexPath = IndexPath(row: index, section: 0)
        switch action {
            case .insert:
                tableView.insertRows(at: [indexPath], with: .bottom)
            case .delete:
                tableView.deleteRows(at: [indexPath], with: .automatic)
            case .move:
                break
        }
    }
    
    func showLogo(_ image: UIImage, at indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? StocksTableViewCell else { return }
        cell.setLogo(image)
    }
    
    func updateQuotes(_ quotes: CompanyQuotes, at indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? StocksTableViewCell else { return }
        cell.companyQuotes = quotes
        
        tableView.refreshControl?.endRefreshing()
    }

    // MARK: - Private methods
    private func setupTableView() {
        tableView.backgroundColor = .View.backgroundColor
        tableView.separatorStyle = .none
        
        tableView.dragInteractionEnabled = true
        tableView.dragDelegate = self
        tableView.dropDelegate = self
        
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.addTarget(self, action: #selector(refresh), for: .valueChanged)
        
        tableView.register(StocksTableViewCell.self, forCellReuseIdentifier: StocksTableViewCell.identifier)
    }
    
    private func setupSearchController() {
        guard let viewModel = viewModel as? SearchCompanyViewModel else { return }
        let searchVC = SearchCompanyVC(viewModel: viewModel)
        viewModel.searchView = searchVC
        
        let searchController = UISearchController(searchResultsController: searchVC)
        navigationItem.searchController = searchController
        
        searchController.searchBar.delegate = searchVC
    }
    
}

// MARK: - TableView Delegate & Datasource
extension StocksVC {

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.watchlist.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: StocksTableViewCell.identifier, for: indexPath)
        
        if let cell = cell as? StocksTableViewCell {
            let company = viewModel.watchlist[indexPath.row]
            cell.companyProfile = company
            
            if let logoUrl = company.logoUrl {
                let logoSize = cell.bounds.height
                viewModel.fetchLogo(from: logoUrl, withSize: Float(logoSize), for: indexPath) 
            }
            
            viewModel.fetchQuotes(for: company, at: indexPath)
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        guard let cell = tableView.cellForRow(at: indexPath) as? StocksTableViewCell else { return nil }
        cell.animate(completion: nil)
        return indexPath
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            viewModel.updateWatchlist(at: indexPath.row, to: nil, with: .delete)
        }
    }
    
}

// MARK: - Drag&Drop
extension StocksVC: UITableViewDragDelegate, UITableViewDropDelegate {
    
    func tableView(_ tableView: UITableView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        [UIDragItem(itemProvider: NSItemProvider())]
    }
    
    func tableView(_ tableView: UITableView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UITableViewDropProposal {
        UITableViewDropProposal(operation: .move, intent: .insertAtDestinationIndexPath)
    }
    
    func tableView(_ tableView: UITableView, performDropWith coordinator: UITableViewDropCoordinator) {
        guard let destinationIndexPath = coordinator.destinationIndexPath else { return }
        for item in coordinator.items {
            if let sourceIndexPath = item.sourceIndexPath {
                viewModel.updateWatchlist(at: sourceIndexPath.row, to: destinationIndexPath.row, with: .move)
                tableView.moveRow(at: sourceIndexPath, to: destinationIndexPath)
                coordinator.drop(item.dragItem, toRowAt: destinationIndexPath)
            }
        }
    }
    
}
