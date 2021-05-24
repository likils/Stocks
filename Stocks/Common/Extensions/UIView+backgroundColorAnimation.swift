//
//  UIView+backgroundColorAnimation.swift
//  Stocks
//
//  Created by likils on 19.05.2021.
//

import UIKit

extension UIView {

    func animateBackgroundColor(with color: UIColor) {
        if backgroundColor == nil {
            backgroundColor = .clear
        }
        let initialColor = backgroundColor!
        
        UIView.animate(withDuration: 0.7) {
            self.layer.backgroundColor = color.cgColor.copy(alpha: 0.4)
        } completion: { _ in
            // .animate used because .autoreverse option lags
            UIView.animate(withDuration: 0.7) {
                self.layer.backgroundColor = initialColor.cgColor
            }
        }
    }
    
}
