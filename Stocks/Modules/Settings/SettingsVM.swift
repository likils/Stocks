//
//  SettingsVM.swift
//  Stocks
//
//  Created by likils on 27.04.2021.
//

import Foundation

class SettingsVM: SettingsViewModel {
    
    // MARK: - Public properties
    let cells: [SettingCell]
    
    // MARK: - Private properties
    private weak var coordinator: SettingsCoordination?
    
    // MARK: - Init
    init(coordinator: SettingsCoordination) {
        self.coordinator = coordinator
        
        cells = [SettingCell.logout(title: "Log out")]
    }
    
    // MARK: - Public methods
    func cellTapped(_ cell: SettingCell) {
        switch cell {
            case .logout(_):
                coordinator?.didFinishClosure?()   
        }
    }
    
}
