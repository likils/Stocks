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
    private let _execute: (@escaping RequestCompletion<Value>) -> Void

// MARK: - Methods

    func execute(with completion: @escaping RequestCompletion<Value>) {
        _execute(completion)
    }
}
