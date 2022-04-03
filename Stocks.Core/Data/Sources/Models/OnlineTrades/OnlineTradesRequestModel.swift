// ----------------------------------------------------------------------------
//
//  OnlineTradesRequestModel.swift
//
//  @likils <likils@icloud.com>
//  Copyright (c) 2022. All rights reserved.
//
// ----------------------------------------------------------------------------

public struct OnlineTradesRequestModel: Codable {

    // MARK: - Properties

    let token: String
}

// ----------------------------------------------------------------------------

extension OnlineTradesRequestModel {

    // MARK: - Construction

    public static func of(token: String) -> Self {
        return Self.init(token: token)
    }
}
