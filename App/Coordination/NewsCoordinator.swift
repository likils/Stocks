//
//  NewsCoordinator.swift
//  Stocks
//
//  Created by likils on 26.04.2021.
//

import UIKit
import SafariServices

protocol NewsCoordination: NavCoordination {
    
    func showWebPage(with url: URL)
    
}

class NewsCoordinator: NewsCoordination {
    
    // MARK: - Public properties
    var navController: UINavigationController
    var didFinishClosure: (() -> ())?
    
    // MARK: - Private properties
    private let cacheService: CacheService
    
    // MARK: - Construction
    init(navController: UINavigationController, cacheService: CacheService) {
        self.navController = navController
        self.cacheService = cacheService
    }
    
    // MARK: - Public Methods
    func start() {
        let vm = NewsVM(coordinator: self, cacheService: cacheService)
        let vc = NewsVC(viewModel: vm)
        navController.viewControllers = [vc]
    }
    
    func showWebPage(with url: URL) {
        let vc = SFSafariViewController(url: url)
        navController.present(vc, animated: true)
    }
    
}
