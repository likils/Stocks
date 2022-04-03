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

    // MARK: - Private Properties

    private let urlRequest: URLRequest

    // MARK: - Construction

    init(urlRequest: URLRequest) {
        self.urlRequest = urlRequest
    }

    // MARK: - Methods

    func execute() async throws -> Data {
        try await URLSession.shared.data(for: self.urlRequest)
    }

    func eraseToAnyRequestTask() -> AnyRequestTask<Value> {
        return AnyRequestTask(requestTask: self)
    }
}
