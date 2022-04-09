// ----------------------------------------------------------------------------
//
//  StocksViewController.swift
//
//  @likils <likils@icloud.com>
//  Copyright (c) 2021. All rights reserved.
//
// ----------------------------------------------------------------------------

import Combine
import StocksData
import StocksSystem
import UIKit

// ----------------------------------------------------------------------------

final class StocksViewController: UITableViewController {
    
    // MARK: - Private Properties

    private let viewModel: StocksViewModel

    private var watchlist: [CompanyProfileModel] = .empty
    private var watchlistSubscriber: AnyCancellable?
    
    // MARK: - Construction
    
    init(viewModel: StocksViewModel) {
        self.viewModel = viewModel

        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Stocks"
        
        setupTableView()
        setupSubscriptions()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        self.viewModel.beginOnlineTradeUpdates()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        self.viewModel.endOnlineTradeUpdates()
    }

    // MARK: - Actions

    private func reloadWatchlist(with companyProfileModels: [CompanyProfileModel]) {
        self.watchlist = companyProfileModels
        self.tableView.reloadData()
    }

    // MARK: - Private Methods

    private func setupTableView() {

        self.tableView? <- {
            $0.backgroundColor = StocksColor.background
            $0.separatorStyle = .none

            $0.dragInteractionEnabled = true
            $0.dragDelegate = self
            $0.dropDelegate = self

            $0.registerCell(StocksTableViewCell.self)
        }
    }

    private func setupSubscriptions() {

        self.watchlistSubscriber = self.viewModel
            .getCompanyProfilesPublisher()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in self?.reloadWatchlist(with: $0) }
    }
}

// MARK: - @protocol UITableViewDelegate

extension StocksViewController {

    // MARK: - Methods

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let company = self.watchlist[indexPath.row]
        self.viewModel.showCompanyDetails(for: company)
    }

    override func tableView(
        _ tableView: UITableView,
        commit editingStyle: UITableViewCell.EditingStyle,
        forRowAt indexPath: IndexPath
    ) {
        if editingStyle == .delete {
            let company = self.watchlist.remove(at: indexPath.row)
            self.viewModel.removeCompany(company)
        }
    }
}

// MARK: - @protocol UITableViewDataSource

extension StocksViewController {

    // MARK: - Methods

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.watchlist.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(StocksTableViewCell.self, for: indexPath)

        let companyProfile = watchlist[indexPath.row]
        cell?.updateView(with: companyProfile)

        let maxLogoSize = cell?.bounds.height ?? 0.0
        let imagePublisher = self.viewModel.getImagePublisher(withSize: maxLogoSize, for: companyProfile)
        cell?.subscribeToImageChanges(with: imagePublisher)

        let onlineTradePublisher = self.viewModel.getOnlineTradePublisher(for: companyProfile)
        cell?.subscribeToOnlineTrade(with: onlineTradePublisher)
        
        return cell ?? UITableViewCell()
    }
}

// MARK: - @protocol UITableViewDragDelegate

extension StocksViewController: UITableViewDragDelegate {

    // MARK: - Methods
    
    func tableView(
        _ tableView: UITableView,
        itemsForBeginning session: UIDragSession,
        at indexPath: IndexPath
    ) -> [UIDragItem] {

        [UIDragItem(itemProvider: NSItemProvider())]
    }
}

// MARK: - @protocol UITableViewDropDelegate

extension StocksViewController: UITableViewDropDelegate {

    // MARK: - Methods

    func tableView(
        _ tableView: UITableView,
        dropSessionDidUpdate session: UIDropSession,
        withDestinationIndexPath destinationIndexPath: IndexPath?
    ) -> UITableViewDropProposal {

        UITableViewDropProposal(operation: .move, intent: .insertAtDestinationIndexPath)
    }

    func tableView(_ tableView: UITableView, performDropWith coordinator: UITableViewDropCoordinator) {

        guard let destinationIndexPath = coordinator.destinationIndexPath else { return }

        let destinationIndex = destinationIndexPath.row

        coordinator.items.forEach { item in

            item.sourceIndexPath?.row <- { sourceIndex in

                let company = self.watchlist.move(fromIndex: sourceIndex, toIndex: destinationIndex)
                self.viewModel.moveCompany(company, to: destinationIndex)

                coordinator.drop(item.dragItem, toRowAt: destinationIndexPath)
            }
        }
    }
}
