// ----------------------------------------------------------------------------
//
//  URLSession+async_await.swift
//
//  @likils <likils@icloud.com>
//  Copyright (c) 2022. All rights reserved.
//
// ----------------------------------------------------------------------------

import Foundation

// ----------------------------------------------------------------------------

extension URLSession {

    @available(iOS, deprecated: 15.0, message: "This extension is no longer necessary. Use API built into SDK")
    func data(for urlRequest: URLRequest) async throws -> Data {

        try await withCheckedThrowingContinuation { continuation in

            self.dataTask(with: urlRequest) { data, response, error in

                if let data = data {
                    continuation.resume(returning: data)
                }
                else {
                    let error = error.map { NetworkError.dataTaskError($0) } ?? NetworkError.badResponseError(response)
                    return continuation.resume(throwing: error)
                }
            }
            .resume()
        }
    }
}
