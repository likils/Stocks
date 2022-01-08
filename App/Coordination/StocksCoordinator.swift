//
//  StocksCoordinator.swift
//  Stocks
//
//  Created by likils on 26.04.2021.
//

import UIKit
import SafariServices

protocol StocksCoordination: NavCoordination {
    
    func showCompanyDetails(_ company: CompanyProfileViewModel)
    func showWebPage(with url: URL)
    
}

class StocksCoordinator: StocksCoordination {
    
    // MARK: - Public properties
    var navController: UINavigationController
    var didFinishClosure: (() -> ())?
    
    // MARK: - Private properties
    private let cacheService: CacheService
    private let webSocketService: WebSocketService
    
    // MARK: - Construction
    init(navController: UINavigationController,
         cacheService: CacheService,
         webSocketService: WebSocketService) {
        
        self.navController = navController
        self.cacheService = cacheService
        self.webSocketService = webSocketService
    }
    
    // MARK: - Public Methods
    func start() {
        let vm = StocksVM(coordinator: self,
                          webSocketService: webSocketService,
                          cacheService: cacheService)
        let vc = StocksVC(viewModel: vm)
        navController.viewControllers = [vc]
    }
    
    func showCompanyDetails(_ company: CompanyProfileViewModel) {
        let vm = CompanyDetailsVM(coordinator: self,
                                  webSocketService: webSocketService,
                                  cacheService: cacheService,
                                  companyProfile: company)
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
    
}
