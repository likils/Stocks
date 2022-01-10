// ----------------------------------------------------------------------------
//
//  Request.swift
//
//  @likils <likils@icloud.com>
//  Copyright (c) 2022. All rights reserved.
//
// ----------------------------------------------------------------------------

public protocol Request {

    associatedtype Value

// MARK: - Methods

    func execute() async throws -> Value
}
