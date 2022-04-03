// ----------------------------------------------------------------------------
//
//  RequestTask.swift
//
//  @likils <likils@icloud.com>
//  Copyright (c) 2022. All rights reserved.
//
// ----------------------------------------------------------------------------

protocol RequestTask {

    associatedtype Value: Codable

    // MARK: - Methods

    func execute() async throws -> Value
}
