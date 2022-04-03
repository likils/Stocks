// ----------------------------------------------------------------------------
//
//  RequestValueTask.swift
//
//  @likils <likils@icloud.com>
//  Copyright (c) 2022. All rights reserved.
//
// ----------------------------------------------------------------------------

import Foundation

// ----------------------------------------------------------------------------

final class RequestValueTask<Value: Codable>: RequestTask {

    // MARK: - Private Properties

    private let urlRequest: URLRequest

    // MARK: - Construction

    init(urlRequest: URLRequest) {
        self.urlRequest = urlRequest
    }

    // MARK: - Methods

    func execute() async throws -> Value {
        do {
            let data = try await URLSession.shared.data(for: self.urlRequest)
            let value = try JSONDecoder().decode(Value.self, from: data)

            return value
        }
        catch {
            throw (error as? NetworkError) ?? NetworkError.valueTaskError(error)
        }
    }

    func eraseToAnyRequestTask() -> AnyRequestTask<Value> {
        return AnyRequestTask(requestTask: self)
    }
}
