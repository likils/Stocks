//
//  GraphView.swift
//  Stocks
//
//  Created by likils on 27.05.2021.
//

import UIKit

class GraphView: UIView {

    // MARK: - Init
    init() {
        super.init(frame: CGRect.zero)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
