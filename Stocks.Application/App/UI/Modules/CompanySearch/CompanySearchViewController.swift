// ----------------------------------------------------------------------------
//
//  CompanySearchTableViewCell.swift
//
//  @likils <likils@icloud.com>
//  Copyright (c) 2022. All rights reserved.
//
// ----------------------------------------------------------------------------

import Combine
import StocksData
import StocksSystem
import UIKit

// ----------------------------------------------------------------------------

final class CompanySearchViewController: UITableViewController {

    // MARK: - Private Properties

    private let viewModel: CompanySearchViewModel

    private var companies: [CompanySearchModel] = .empty
    private var companiesSubscriber: AnyCancellable?

    // MARK: - Construction

    init(viewModel: CompanySearchViewModel) {
        self.viewModel = viewModel
        super.init(style: .plain)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Methods

    override func viewDidLoad() {
        super.viewDidLoad()

        setupTableView()
        setupSubscriptions()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        self.viewModel.viewDidAppear()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        self.viewModel.viewWillDisappear()
    }

    // MARK: - Actions

    private func reloadSearchlist(with companies: [CompanySearchModel]) {
        self.companies = companies
        self.tableView.reloadSections(IndexSet(integer: 0), with: .fade)
    }

    // MARK: - Private Methods

    private func setupTableView() {

        self.tableView? <- {
            $0.separatorStyle = .none
            $0.registerCell(CompanySearchTableViewCell.self)
        }
    }

    private func setupSubscriptions() {

        self.companiesSubscriber = self.viewModel
            .getCompanySearchPublisher()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in self?.reloadSearchlist(with: $0) }
    }

    // MARK: - Inner Types

    private enum Const {
        static let cellHeight: CGFloat = 54
    }
}

// MARK: - @protocol UISearchBarDelegate

extension CompanySearchViewController: UISearchBarDelegate {

    // MARK: - Methods
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.viewModel.searchCompany(with: searchText)
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.viewModel.searchCompany(with: "")
    }
}

// MARK: - @protocol UITableViewDelegate

extension CompanySearchViewController {

    // MARK: - Methods

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let company = self.companies[indexPath.row]
        self.viewModel.showCompanyDetails(for: company)
    }
}

// MARK: - @protocol UITableViewDataSource

extension CompanySearchViewController {

    // MARK: - Methods

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.companies.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(CompanySearchTableViewCell.self, for: indexPath)

        let company = self.companies[indexPath.row]
        cell?.updateView(with: company)

        let separatorIsHidden = (self.companies.count - 1) == indexPath.row
        cell?.updateSeparator(isHidden: separatorIsHidden)

        return cell ?? UITableViewCell()
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Const.cellHeight
    }
}
