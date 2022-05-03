// ----------------------------------------------------------------------------
//
//  CompanySearchViewController.swift
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

    // MARK: - Subviews

    private let loadingDataLabel = UILabel() <- {
        $0.font = StocksFont.body
        $0.textColor = StocksColor.secondary
        $0.textAlignment = .center
        $0.text = "Loading..."
    }

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

        self.loadingDataLabel.isHidden = !companies.isEmpty
    }

    // MARK: - Private Methods

    private func setupTableView() {

        self.tableView? <- {
            $0.separatorStyle = .none
            $0.registerCell(CompanySearchCell.self)
        }

        self.tableView.addSubview(self.loadingDataLabel)
        self.loadingDataLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(20)
            make.centerX.equalToSuperview()
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
        static let cellHeight: CGFloat = 54.0
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
        return tableView.dequeueReusableCell(CompanySearchCell.self, for: indexPath) <- {

            let company = self.companies[indexPath.row]
            $0.updateView(with: company)

            let separatorIsHidden = (self.companies.count - 1) == indexPath.row
            $0.updateSeparator(isHidden: separatorIsHidden)
        }
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Const.cellHeight
    }
}
