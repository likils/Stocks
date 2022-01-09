// ----------------------------------------------------------------------------
//
//  SceneDelegate.swift
//
//  @likils <likils@icloud.com>
//  Copyright (c) 2021. All rights reserved.
//
// ----------------------------------------------------------------------------

import UIKit

// ----------------------------------------------------------------------------

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

// MARK: - Private Properties

    private var appCoordinator: AppCoordinator?

// MARK: - Methods

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let scene = (scene as? UIWindowScene) else { return }

        let window = UIWindow(windowScene: scene)

        let appCoordinator = AppCoordinator(window: window)
        self.appCoordinator = appCoordinator
    }
}

