//
//  CellBackgroundView.swift
//  Stocks
//
//  Created by likils on 12.05.2021.
//

import UIKit

class CellBackgroundView: UIView {

    // MARK: - Init
    init() {
        super.init(frame: CGRect.zero)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public methods
    func animate(completion: (() -> Void)?) {
        UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.1, delay: 0, options: []) { 
            self.layer.shadowOpacity = 0
            self.transform = CGAffineTransform.init(scaleX: 0.99, y: 0.99)
            self.backgroundColor = .View.pressButtonColor
        }
        completion: { state in
            if state == .end {
                UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.1, delay: 0, options: []) { 
                    self.layer.shadowOpacity = 0.12
                    self.transform = CGAffineTransform.identity
                    self.backgroundColor = .white
                }
                completion: { state in
                    if state == .end {
                        completion?()
                    }
                }
            }
        }
    }

    // MARK: - Private methods
    private func setupView() {
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .white
        layer.cornerRadius = 16
        layer.shadowRadius = 4
        layer.shadowOpacity = 0.12
        layer.shadowOffset = CGSize(width: 0, height: 0)
        layer.shadowColor = UIColor.View.shadowColor.cgColor
    }
    
}
