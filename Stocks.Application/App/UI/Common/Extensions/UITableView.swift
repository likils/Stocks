// ----------------------------------------------------------------------------
//
//  UITableView.swift
//
//  @likils <likils@icloud.com>
//  Copyright (c) 2022. All rights reserved.
//
// ----------------------------------------------------------------------------

import UIKit

// ----------------------------------------------------------------------------

extension UITableView {

    // MARK: - Methods

    func registerCell<T: UITableViewCell>(_ cellType: T.Type) {
        register(cellType, forCellReuseIdentifier: cellType.identifier)
    }

    func dequeueReusableCell<T: UITableViewCell>(_ cellType: T.Type, for indexPath: IndexPath) -> T {
        let reusableCell = dequeueReusableCell(withIdentifier: cellType.identifier, for: indexPath) as? T
        return reusableCell!
    }
}
