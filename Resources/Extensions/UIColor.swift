// ----------------------------------------------------------------------------
//
//  LeftAssignmentPrecedence.swift
//
//  @likils <likils@icloud.com>
//  Copyright (c) 2021. All rights reserved.
//
// ----------------------------------------------------------------------------

import UIKit

// ----------------------------------------------------------------------------

extension UIColor {
    
// MARK: - RGB Construction

    convenience init(rgb: Int) {
        let r = CGFloat((rgb & 0xFF0000) >> 0x10) / 255.0
        let g = CGFloat((rgb & 0x00FF00) >> 0x08) / 255.0
        let b = CGFloat((rgb & 0x0000FF) >> 0x00) / 255.0
        let a = CGFloat(1.0)

        self.init(red: r, green: g, blue: b, alpha: a)
    }
}
