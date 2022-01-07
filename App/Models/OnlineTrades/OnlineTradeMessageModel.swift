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

    public let companySymbol: String

    public let messageType: MessageType

// MARK: - Coding Keys

    private enum CodingKeys: String, CodingKey {
        case companySymbol = "symbol"
        case messageType = "type"
    }
}
