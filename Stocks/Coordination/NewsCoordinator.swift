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
    private let newsService: NewsService
    private let cacheService: CacheService
    
    // MARK: - Init
    init(navController: UINavigationController, newsService: NewsService, cacheService: CacheService) {
        self.navController = navController
        self.newsService = newsService
        self.cacheService = cacheService
    }
    
    // MARK: - Public methods
    func start() {
        let vm = NewsVM(coordinator: self, newsService: newsService, cacheService: cacheService)
        let vc = NewsVC(viewModel: vm)
        navController.viewControllers = [vc]
    }
    
}
