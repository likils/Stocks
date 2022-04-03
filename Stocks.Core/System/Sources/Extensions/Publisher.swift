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
}
