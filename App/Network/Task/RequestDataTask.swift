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

    func execute(with completion: @escaping RequestCompletion<Value>) {
        URLSession.shared.dataTask(with: urlRequest) { data, response, error in

            let result: RequestResult<Value>

            if let error = error {
                result = .failure(.dataTaskError(error))
            }
            else if let data = data {
                do {
                    let value = try JSONDecoder().decode(Value.self, from: data)
                    result = .success(value)
                } catch {
                    result = .failure(.serializationError(error))
                }
            }
            else {
                result = .failure(.dataTaskBadResponse(response))
            }

            completion(result)
        }
        .resume()
    }

    func eraseToAnyRequestTask() -> AnyRequestTask<Value> {
        return anyRequestTask
    }
}
