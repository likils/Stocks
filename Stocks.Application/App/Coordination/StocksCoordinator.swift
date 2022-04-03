// ----------------------------------------------------------------------------
//
//  StocksCoordinator.swift
//
//  @likils <likils@icloud.com>
//  Copyright (c) 2021. All rights reserved.
//
// ----------------------------------------------------------------------------

import SafariServices
import UIKit

// ----------------------------------------------------------------------------

protocol StocksCoordination: Coordinator {

    // MARK: - Methods

    func showCompanyDetails(_ company: CompanyProfileModel)
    func showWebPage(with url: URL)
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
    
    func showCompanyDetails(_ company: CompanyProfileModel) {
        let vm = CompanyDetailsVM(coordinator: self, companyProfile: company)
        let vc = CompanyDetailsVC(viewModel: vm)

        didFinishClosure = { [weak self] in
            self?.navController.popViewController(animated: true)
        }

        self.navController.pushViewController(vc, animated: true)
    }
    
    func showWebPage(with url: URL) {
        let vc = SFSafariViewController(url: url)
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
