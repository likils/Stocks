// ----------------------------------------------------------------------------
//
//  WebSocketTask.swift
//
//  @likils <likils@icloud.com>
//  Copyright (c) 2022. All rights reserved.
//
// ----------------------------------------------------------------------------

import Combine
import Foundation

// ----------------------------------------------------------------------------

protocol WebSocketTask {

    associatedtype Value: Codable

    // MARK: - Methods

    func getPublisher() -> AnyPublisher<Value, Error>

    func openConnection()

    func closeConnection()

    func sendMessage(_ message: RequestEntity)
}
