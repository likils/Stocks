//
//  StocksCoordinator.swift
//  Stocks
//
//  Created by likils on 26.04.2021.
//

import UIKit

protocol StocksCoordination: NavCoordination {
    
}

class StocksCoordinator: StocksCoordination {
    
    // MARK: - Public properties
    var navController: UINavigationController
    var didFinishClosure: (() -> ())?
    
    // MARK: - Private properties
    private let service: RequestService
    
    // MARK: - Init
    init(navController: UINavigationController, service: RequestService) {
        self.navController = navController
        self.service = service
    }
    
    // MARK: - Public methods
    func start() {
        
    }
    
}
