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

final class RequestDataTask: RequestTask {

// MARK: - Construction

    init(urlRequest: URLRequest) {
        self.urlRequest = urlRequest
    }

// MARK: - Private Properties

    private let urlRequest: URLRequest
    private lazy var anyRequestTask = AnyRequestTask(requestTask: self)

// MARK: - Methods

    func execute() async throws -> Data {
        let data = try await URLSession.shared.data(for: urlRequest)
        return data
    }

    func eraseToAnyRequestTask() -> AnyRequestTask<Value> {
        return anyRequestTask
    }
}
