// ----------------------------------------------------------------------------
//
//  AnyRequestTask.swift
//
//  @likils <likils@icloud.com>
//  Copyright (c) 2022. All rights reserved.
//
// ----------------------------------------------------------------------------

struct AnyRequestTask<Value: Codable>: RequestTask {

// MARK: - Construction

    init<RT: RequestTask>(requestTask: RT) where RT.Value == Value {
        _requestTask = requestTask as AnyObject
        _execute = requestTask.execute
    }

// MARK: - Private Properties

    private let _requestTask: AnyObject
    private let _execute: () async throws -> (Value)

// MARK: - Methods

    func execute() async throws -> Value {
        try await _execute()
    }
}
