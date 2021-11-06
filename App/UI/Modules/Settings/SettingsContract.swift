//
//  SettingsContract.swift
//  Stocks
//
//  Created by likils on 27.04.2021.
//

import Foundation

enum SettingCell {
    
    case logout(title: String)
    
}

protocol SettingsViewModel: AnyObject {
    
    var cells: [SettingCell] { get }
    
    func cellTapped(_ cell: SettingCell)
    
}
