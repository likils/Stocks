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

// MARK: - Construction

    init(_ webSocketTask: AnyWebSocketTask<Value>) {
        self.webSocketTask = webSocketTask
        webSocketTask.openConnection()
    }

    deinit {
        webSocketTask.closeConnection()
    }

// MARK: - Private Properties

    private let webSocketTask: AnyWebSocketTask<Value>

// MARK: - Methods

    public func getPublisher() -> AnyPublisher<Value, NetworkError> {
        return webSocketTask.getPublisher()
    }

    public func sendMessage<Message: Encodable>(_ message: Message) throws {
        let requestEntity = try RequestEntity(requestModel: message)
        webSocketTask.sendMessage(requestEntity)
    }
}
