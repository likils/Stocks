// ----------------------------------------------------------------------------
//
//  UIView.swift
//
//  @likils <likils@icloud.com>
//  Copyright (c) 2021. All rights reserved.
//
// ----------------------------------------------------------------------------

import UIKit

// ----------------------------------------------------------------------------

extension UIView {

    // MARK: - Methods

    func animateBackgroundColor(with color: UIColor) {

        let initialColor = (self.backgroundColor == nil) ? .clear : self.backgroundColor!

        UIView.animate(withDuration: 0.7) {
            self.layer.backgroundColor = color.cgColor.copy(alpha: 0.4)
        } completion: { _ in
            UIView.animate(withDuration: 0.7) {
                self.layer.backgroundColor = initialColor.cgColor
            }
        }
    }
}
