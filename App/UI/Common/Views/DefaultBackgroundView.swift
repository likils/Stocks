// ----------------------------------------------------------------------------
//
//  DefaultBackgroundView.swift
//
//  @likils <likils@icloud.com>
//  Copyright (c) 2021. All rights reserved.
//
// ----------------------------------------------------------------------------

import UIKit

// ----------------------------------------------------------------------------

final class DefaultBackgroundView: UIView {

// MARK: - Construction

    init() {
        super.init(frame: CGRect.zero)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

// MARK: - Private Methods

    private func setupView() {
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .white

        layer.cornerRadius = 16.0
        layer.shadowColor = Color.shadow.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 0)
        layer.shadowOpacity = 0.12
        layer.shadowRadius = 4.0
    }
}
