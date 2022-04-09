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

protocol SettingsCoordination: Coordinator {
    // does nothing
}

// ----------------------------------------------------------------------------

final class SettingsCoordinator: SettingsCoordination {
    
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
        showSettings()
    }
    
    // MARK: - Private Methods

    private func showSettings() {

        let presenter = SettingsPresenter(coordinator: self)
        let controller = SettingsViewController(viewOutput: presenter)
        presenter.viewInput = controller

        self.navController.viewControllers = [controller]
    }
}
