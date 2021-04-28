//
//  Coordination.swift
//  Stocks
//
//  Created by likils on 26.04.2021.
//

import UIKit

protocol Coordination: AnyObject {
    
    var didFinishClosure: (() -> ())? { get set }
    
    func start()
    
}

protocol NavCoordination: Coordination {
    
    var navController: UINavigationController { get set }
    
}
