// ----------------------------------------------------------------------------
//
//  Publisher.swift
//
//  @likils <likils@icloud.com>
//  Copyright (c) 2022. All rights reserved.
//
// ----------------------------------------------------------------------------

import Combine

// ----------------------------------------------------------------------------

extension Publisher {
    
    // MARK: - Methods
    
    public func asyncFlatMap<T>(
        _ transform: @escaping (Output) async -> T
    ) -> Publishers.FlatMap<Future<T, Never>, Self> {
        
        flatMap { value in
            Future { promise in
                
                Task {
                    let output = await transform(value)
                    promise(.success(output))
                }
            }
        }
    }

    public func tryAsyncFlatMap<T>(
        _ transform: @escaping (Output) async throws -> T
    ) -> Publishers.FlatMap<Future<T, Error>, Self> {

        flatMap { value in
            Future { promise in

                Task {
                    do {
                        let output = try await transform(value)
                        promise(.success(output))
                    }
                    catch {
                        promise(.failure(error))
                    }
                }
            }
        }
    }
}
