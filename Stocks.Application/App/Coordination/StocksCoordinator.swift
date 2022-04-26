// ----------------------------------------------------------------------------
//
//  StocksCoordinator.swift
//
//  @likils <likils@icloud.com>
//  Copyright (c) 2021. All rights reserved.
//
// ----------------------------------------------------------------------------

import StocksData
import SafariServices
import UIKit

// ----------------------------------------------------------------------------

protocol StocksCoordination: Coordinator {

    // MARK: - Methods

    func showCompanyDetails(with company: CompanyProfileDataModel)

    func showWebPage(with link: URL)
}

// ----------------------------------------------------------------------------

final class StocksCoordinator: StocksCoordination {
    
    // MARK: - Properties

    var didFinishClosure: (() -> ())?
    
    // MARK: - Private Properties

    private let navController: UINavigationController
    
    // MARK: - Construction

    init(navController: UINavigationController) {
        self.navController = navController
    }
    
    // MARK: - Methods

    func start() {
        showStocks()
    }
    
    func showCompanyDetails(with company: CompanyProfileDataModel) {
        let vm = CompanyDetailsViewModelImpl(coordinator: self, companyProfileDataModel: company)
        let vc = CompanyDetailsViewController(viewModel: vm)

        didFinishClosure = { [weak self] in
            self?.navController.popViewController(animated: true)
        }

        self.navController.pushViewController(vc, animated: true)
    }
    
    func showWebPage(with link: URL) {
        let vc = SFSafariViewController(url: link)
        self.navController.present(vc, animated: true)
    }

    // MARK: - Private Methods

    private func showStocks() {

        let searchViewModel = CompanySearchViewModelImpl(coordinator: self)
        let searchViewController = CompanySearchViewController(viewModel: searchViewModel)

        let searchController = UISearchController(searchResultsController: searchViewController)
        searchController.searchBar.delegate = searchViewController

        let vm = StocksViewModelImpl(coordinator: self)
        let vc = StocksViewController(viewModel: vm)
        vc.navigationItem.searchController = searchController

        self.navController.viewControllers = [vc]
    }
}
