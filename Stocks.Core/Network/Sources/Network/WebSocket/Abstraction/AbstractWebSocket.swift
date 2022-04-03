// ----------------------------------------------------------------------------
//
//  AbstractWebSocket.swift
//
//  @likils <likils@icloud.com>
//  Copyright (c) 2022. All rights reserved.
//
// ----------------------------------------------------------------------------

import Combine

// ----------------------------------------------------------------------------

public class AbstractWebSocket<Value: Codable>: WebSocket {

    // MARK: - Private Properties

    private let webSocketTask: AnyWebSocketTask<Value>

    // MARK: - Construction

    init(_ webSocketTask: AnyWebSocketTask<Value>) {
        self.webSocketTask = webSocketTask
        webSocketTask.openConnection()
    }

    deinit {
        self.webSocketTask.closeConnection()
    }

    // MARK: - Methods

    public func getPublisher() -> AnyPublisher<Value, Error> {
        return self.webSocketTask.getPublisher()
    }

    public func sendMessage<Message: Encodable>(_ message: Message) throws {
        let requestEntity = try RequestEntity(requestModel: message)
        self.webSocketTask.sendMessage(requestEntity)
    }
}
