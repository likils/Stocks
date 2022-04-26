// ----------------------------------------------------------------------------
//
//  ResolverDI.swift
//
//  @likils <likils@icloud.com>
//  Copyright (c) 2021. All rights reserved.
//
// ----------------------------------------------------------------------------

import StocksNetwork
import StocksPersistence
import Resolver

// ----------------------------------------------------------------------------

extension Resolver: ResolverRegistering {

    // MARK: - Methods

    public static func registerAllServices() {
        registerRepositories()
        registerRequestFactories()
    }
}
