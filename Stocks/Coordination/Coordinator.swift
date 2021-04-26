//
//  Coordinator.swift
//  Stocks
//
//  Created by likils on 26.04.2021.
//

import UIKit

protocol Coordinator: class {
    
    var didFinishClosure: (() -> ())? { get set }
    
    func start()
    
}

protocol WindowCoordinator: Coordinator {
    
    var window: UIWindow { get set }
    
}

protocol NavCoordinator: Coordinator {
    
    var navController: UINavigationController { get set }
    
}

protocol TabCoordinator: Coordinator {
    
    var tabController: UITabBarController { get set }
    
}
