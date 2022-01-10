// ----------------------------------------------------------------------------
//
//  RequestDataTask.swift
//
//  @likils <likils@icloud.com>
//  Copyright (c) 2022. All rights reserved.
//
// ----------------------------------------------------------------------------

import Foundation

// ----------------------------------------------------------------------------

class RequestDataTask<Value: Codable>: RequestTask {

// MARK: - Construction

    init(urlRequest: URLRequest) {
        self.urlRequest = urlRequest
    }

// MARK: - Private Properties

    private let urlRequest: URLRequest
    private lazy var anyRequestTask = AnyRequestTask(requestTask: self)

// MARK: - Methods

    func execute() async throws -> Value {
        let (data, _) = try await URLSession.shared.data(for: urlRequest)
        let value = try JSONDecoder().decode(Value.self, from: data)
        return value
    }

    func eraseToAnyRequestTask() -> AnyRequestTask<Value> {
        return anyRequestTask
    }
}
