//
//  UIColor.swift
//  Stocks
//
//  Created by likils on 28.04.2021.
//

import UIKit

extension UIColor {
    // MARK: - Color Scheme
    enum View {
        
        static var pressButtonColor: UIColor {
            UIColor(rgb: 0xF1F1F1)
        }
        
        static var backgroundColor: UIColor {
            UIColor(rgb: 0xF8F8FA)
        }
        
        static var shadowColor: UIColor {
            UIColor(rgb: 0x303040)
        }
        
        static var defaultAppColor: UIColor {
            UIColor(rgb: 0x8D75F2)
        }
        
    }
    
    enum Text {
        
        static var primaryColor: UIColor {
            UIColor(rgb: 0x373737)
        }
        
        static var secondaryColor: UIColor {
            UIColor(rgb: 0x9A9CA5)
        }
        
        static var positivePriceColor: UIColor {
            UIColor(rgb: 0x3FD672)
        }
        
        static var negativePriceColor: UIColor {
            UIColor(rgb: 0xD6463F)
        }
        
    }
    
    // MARK: - RGB Init
    convenience init(rgb: Int) {
        self.init(
            red: CGFloat((rgb & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgb & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgb & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
}
