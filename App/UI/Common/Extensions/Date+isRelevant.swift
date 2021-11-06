//
//  Date+isRelevant.swift
//  Stocks
//
//  Created by likils on 20.05.2021.
//

import Foundation

extension Date {
    
    var isRelevant: Bool {
        Calendar.current.isDateInYesterday(self)
    }
    
}
