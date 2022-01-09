// ----------------------------------------------------------------------------
//
//  SettingsCoordinator.swift
//
//  @likils <likils@icloud.com>
//  Copyright (c) 2021. All rights reserved.
//
// ----------------------------------------------------------------------------

import UIKit

// ----------------------------------------------------------------------------

protocol SettingsCoordination: Coordination {
    // does nothing
}

// ----------------------------------------------------------------------------

final class SettingsCoordinator: SettingsCoordination {
    
// MARK: - Properties

    var didFinishClosure: (() -> ())?
    
// MARK: - Private properties

    private let navController: UINavigationController

// MARK: - Construction

    init(navController: UINavigationController) {
        self.navController = navController

        showSettings()
    }
    
// MARK: - Private Methods

    private func showSettings() {
        let vm = SettingsVM(coordinator: self)
        let vc = SettingsVC(viewModel: vm)

        navController.viewControllers = [vc]
    }
}
