// ----------------------------------------------------------------------------
//
//  NetworkError.swift
//
//  @likils <likils@icloud.com>
//  Copyright (c) 2022. All rights reserved.
//
// ----------------------------------------------------------------------------

import Foundation

// ----------------------------------------------------------------------------

public enum NetworkError: Error {

    // MARK: - General

    case imageConversionError(String)
    case requestEntitySerializationError(Error)

    // MARK: - DataTask

    case badResponseError(URLResponse?)
    case dataTaskError(Error)
    case valueTaskError(Error)

    // MARK: - WebSocket

    case webSocketPingError(Error)
    case webSocketResultError(Error)
    case webSocketResultSerializationError(Error)
    case webSocketSendMessageError(Error)
}
