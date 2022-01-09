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

protocol StocksCoordination: Coordination {

// MARK: - Methods

    func showCompanyDetails(_ company: CompanyProfileViewModel)
    func showWebPage(with url: URL)
}

// ----------------------------------------------------------------------------

final class StocksCoordinator: StocksCoordination {
    
// MARK: - Properties

    var didFinishClosure: (() -> ())?
    
// MARK: - Private Properties

    private let navController: UINavigationController
    private let cacheService: CacheService
    private let webSocketService: WebSocketService
    
// MARK: - Construction

    init(
        navController: UINavigationController,
        cacheService: CacheService,
        webSocketService: WebSocketService
    ) {
        self.navController = navController
        self.cacheService = cacheService
        self.webSocketService = webSocketService

        showStocks()
    }
    
// MARK: - Methods
    
    func showCompanyDetails(_ company: CompanyProfileViewModel) {
        let vm = CompanyDetailsVM(
            coordinator: self,
            webSocketService: webSocketService,
            cacheService: cacheService,
            companyProfile: company
        )
        let vc = CompanyDetailsVC(viewModel: vm)

        didFinishClosure = {
            self.navController.popViewController(animated: true)
        }

        navController.pushViewController(vc, animated: true)
    }
    
    func showWebPage(with url: URL) {
        let vc = SFSafariViewController(url: url)
        navController.present(vc, animated: true)
    }

// MARK: - Private Methods

    private func showStocks() {
        let vm = StocksVM(
            coordinator: self,
            webSocketService: webSocketService,
            cacheService: cacheService
        )
        let vc = StocksVC(viewModel: vm)

        navController.viewControllers = [vc]
    }
}
