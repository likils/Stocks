// ----------------------------------------------------------------------------
//
//  AnyWebSocketTask.swift
//
//  @likils <likils@icloud.com>
//  Copyright (c) 2022. All rights reserved.
//
// ----------------------------------------------------------------------------

import Combine
import Foundation

// ----------------------------------------------------------------------------

struct AnyWebSocketTask<Value: Codable>: WebSocketTask {

// MARK: - Construction

    init<WST: WebSocketTask>(webSocketTask: WST) where WST.Value == Value {
        _webSocketTask = webSocketTask as AnyObject
        _getPublisher = webSocketTask.getPublisher
        _openConnection = webSocketTask.openConnection
        _closeConnection = webSocketTask.closeConnection
        _sendMessage = webSocketTask.sendMessage
    }

// MARK: - Private Properties

    private let _webSocketTask: AnyObject
    private let _getPublisher: () -> AnyPublisher<Value, NetworkError>
    private let _openConnection: () -> Void
    private let _closeConnection: () -> Void
    private let _sendMessage: (RequestEntity) -> Void

// MARK: - Methods

    func getPublisher() -> AnyPublisher<Value, NetworkError> {
        _getPublisher()
    }

    func openConnection() {
        _openConnection()
    }

    func closeConnection() {
        _closeConnection()
    }

    func sendMessage(_ message: RequestEntity) {
        _sendMessage(message)
    }
}
