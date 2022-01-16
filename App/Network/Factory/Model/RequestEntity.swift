// ----------------------------------------------------------------------------
//
//  RequestEntity.swift
//
//  @likils <likils@icloud.com>
//  Copyright (c) 2022. All rights reserved.
//
// ----------------------------------------------------------------------------

import Foundation

// ----------------------------------------------------------------------------

struct RequestEntity {

// MARK: - Construction

    init<RequestModel: Encodable>(requestModel: RequestModel) throws {
        do {
            let requestModelData = try JSONEncoder().encode(requestModel)

            data = requestModelData
            queryItems = try JSONDecoder().decode([String: String].self, from: requestModelData)
        }
        catch {
            throw NetworkError.requestEntitySerializationError(error)
        }
    }

// MARK: - Properties

    let data: Data
    let queryItems: [String: String]
}
