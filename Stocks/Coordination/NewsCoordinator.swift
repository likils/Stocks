//
//  NewsCoordinator.swift
//  Stocks
//
//  Created by likils on 26.04.2021.
//

import UIKit

protocol NewsCoordination: NavCoordination {
    
}

class NewsCoordinator: NewsCoordination {
    
    // MARK: - Public properties
    var navController: UINavigationController
    var didFinishClosure: (() -> ())?
    
    // MARK: - Private properties
    private let service: NewsService
    
    // MARK: - Init
    init(navController: UINavigationController, service: NewsService) {
        self.navController = navController
        self.service = service
    }
    
    // MARK: - Public methods
    func start() {
        let vm = NewsVM(coordinator: self, newsService: service)
        let vc = NewsVC(viewModel: vm)
        navController.viewControllers = [vc]
    }
    
}
