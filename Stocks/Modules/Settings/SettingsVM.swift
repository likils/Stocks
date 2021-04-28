//
//  SettingsVM.swift
//  Stocks
//
//  Created by likils on 27.04.2021.
//

import Foundation

class SettingsVM: SettingsViewModel {
    
    // MARK: - Private properties
    private weak var coordinator: SettingsCoordination?
    
    // MARK: - Init
    init(coordinator: SettingsCoordination) {
        self.coordinator = coordinator
    }
    
    // MARK: - Public methods
    func logout() {
        coordinator?.didFinishClosure?()
    }
    
}
