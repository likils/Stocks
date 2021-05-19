//
//  UIView+snapshot.swift
//  Stocks
//
//  Created by likils on 19.05.2021.
//

import UIKit

extension UIView {
    
    func takeSnapshot() -> UIView {
        UIGraphicsBeginImageContextWithOptions(bounds.size, false, 0)
        if let context = UIGraphicsGetCurrentContext() {
            layer.render(in: context)
        }
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        let view = UIImageView(image: image)
        view.layer.shadowRadius = 4
        view.layer.shadowOpacity = 0.12
        view.layer.shadowOffset = CGSize(width: 0, height: 0)
        
        return view
    }
    
}
