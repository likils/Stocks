// ----------------------------------------------------------------------------
//
//  RequestProvider.swift
//
//  @likils <likils@icloud.com>
//  Copyright (c) 2022. All rights reserved.
//
// ----------------------------------------------------------------------------

import Foundation

// ----------------------------------------------------------------------------

protocol RequestProvider {

    // MARK: - Properties

    var link: URL { get }

    var headerFields: [String: String] { get }

    var path: String { get }
}
