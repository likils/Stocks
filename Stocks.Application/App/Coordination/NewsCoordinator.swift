// ----------------------------------------------------------------------------
//
//  NewsCoordinator.swift
//
//  @likils <likils@icloud.com>
//  Copyright (c) 2021. All rights reserved.
//
// ----------------------------------------------------------------------------

import SafariServices
import StocksData
import UIKit

// ----------------------------------------------------------------------------

protocol NewsCoordination: Coordinator {

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
    }

    // MARK: - Methods

    func start() {
        showNews()
    }

    // MARK: - Methods

    func showWebPage(with url: URL) {
        let vc = SFSafariViewController(url: url)
        self.navController.present(vc, animated: true)
    }

    // MARK: - Private Methods

    private func showNews() {

        let newsCategories: [NewsCategory] = [.general, .forex, .crypto, .merger]
        let vm = NewsViewModelImpl(coordinator: self, newsCategories: newsCategories)
        let vc = NewsViewController(viewModel: vm)

        self.navController.viewControllers = [vc]
    }
}
