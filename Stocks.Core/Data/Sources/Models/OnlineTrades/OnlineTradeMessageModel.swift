// ----------------------------------------------------------------------------
//
//  OnlineTradeMessageModel.swift
//
//  @likils <likils@icloud.com>
//  Copyright (c) 2022. All rights reserved.
//
// ----------------------------------------------------------------------------

public struct OnlineTradeMessageModel: Codable {

    // MARK: - Properties

    public let companyTicker: String

    public let messageType: MessageType

    // MARK: - Coding Keys

    private enum CodingKeys: String, CodingKey {
        case companyTicker = "symbol"
        case messageType = "type"
    }
}

// ----------------------------------------------------------------------------

extension OnlineTradeMessageModel {

    // MARK: - Construction

    public static func of(companyTicker: String, messageType: MessageType) -> Self {
        return Self.init(companyTicker: companyTicker, messageType: messageType)
    }
}
