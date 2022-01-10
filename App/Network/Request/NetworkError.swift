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

    case badResponseError(URLResponse?)

    case dataTaskError(Error)

    case requestEntitySerializationError(Error)
}
