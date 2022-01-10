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

    init<RequestModel: Codable>(requestModel: RequestModel) throws {
        do {
            let requestModelData = try JSONEncoder().encode(requestModel)
            queryItems = try JSONDecoder().decode([String: String].self, from: requestModelData)
        }
        catch {
            throw NetworkError.requestEntitySerializationError(error)
        }
    }

// MARK: - Properties

    let queryItems: [String: String]
}
