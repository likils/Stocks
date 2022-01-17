// ----------------------------------------------------------------------------
//
//  Coordination.swift
//
//  @likils <likils@icloud.com>
//  Copyright (c) 2021. All rights reserved.
//
// ----------------------------------------------------------------------------

import UIKit

// ----------------------------------------------------------------------------

protocol Coordination: AnyObject {

// MARK: - Properties

    var didFinishClosure: (() -> ())? { get set }

// MARK: - Methods

    func start()
}
