// ----------------------------------------------------------------------------
//
//  WebSocket.swift
//
//  @likils <likils@icloud.com>
//  Copyright (c) 2022. All rights reserved.
//
// ----------------------------------------------------------------------------

import Combine

// ----------------------------------------------------------------------------

public protocol WebSocket {

    associatedtype Value: Codable

    // MARK: - Methods

    func getPublisher() -> AnyPublisher<Value, Error>

    func sendMessage<Message: Encodable>(_ message: Message) throws
}
