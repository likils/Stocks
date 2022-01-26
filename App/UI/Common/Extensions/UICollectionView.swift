// ----------------------------------------------------------------------------
//
//  UICollectionView.swift
//
//  @likils <likils@icloud.com>
//  Copyright (c) 2022. All rights reserved.
//
// ----------------------------------------------------------------------------

import UIKit

// ----------------------------------------------------------------------------

extension UICollectionView {

// MARK: - Methods

    func registerCell<T: UICollectionViewCell>(_ cellType: T.Type) {
        register(cellType, forCellWithReuseIdentifier: cellType.identifier)
    }

    func dequeueReusableCell<T: UICollectionViewCell>(_ cellType: T.Type, for indexPath: IndexPath) -> T? {
        let reusableCell = dequeueReusableCell(withReuseIdentifier: cellType.identifier, for: indexPath) as? T
        return reusableCell
    }
}
