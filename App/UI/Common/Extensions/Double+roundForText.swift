//
//  Double+roundForText.swift
//  Stocks
//
//  Created by likils on 12.05.2021.
//

import Foundation

extension Double {
    
    var roundForText: String {
        String(format: "%.2f", self).replacingOccurrences(of: ".", with: ",")
    }
    
}
