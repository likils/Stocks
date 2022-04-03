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

    // MARK: - Properties

    let data: Data

    let queryItems: [String: String]

    // MARK: - Construction

    init<RequestModel: Encodable>(requestModel: RequestModel) throws {
        do {
            let requestModelData = try JSONEncoder().encode(requestModel)

            self.data = requestModelData
            self.queryItems = try JSONDecoder().decode([String: String].self, from: requestModelData)
        }
        catch {
            throw NetworkError.requestEntitySerializationError(error)
        }
    }
}
