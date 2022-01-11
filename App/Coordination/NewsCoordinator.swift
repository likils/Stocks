// ----------------------------------------------------------------------------
//
//  NewsCoordinator.swift
//
//  @likils <likils@icloud.com>
//  Copyright (c) 2021. All rights reserved.
//
// ----------------------------------------------------------------------------

import SafariServices
import UIKit

// ----------------------------------------------------------------------------

protocol NewsCoordination: Coordination {

// MARK: - Methods

    func showWebPage(with url: URL)
}

// ----------------------------------------------------------------------------

final class NewsCoordinator: NewsCoordination {

// MARK: - Properties

    var didFinishClosure: (() -> ())?

// MARK: - Private Properties

    private let navController: UINavigationController

// MARK: - Construction

    init(navController: UINavigationController) {
        self.navController = navController

        showNews()
    }
    
// MARK: - Methods

    func showWebPage(with url: URL) {
        let vc = SFSafariViewController(url: url)
        navController.present(vc, animated: true)
    }

// MARK: - Private Methods

    private func showNews() {
        let vm = NewsVM(coordinator: self)
        let vc = NewsVC(viewModel: vm)

        navController.viewControllers = [vc]
    }
}
