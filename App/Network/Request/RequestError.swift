// ----------------------------------------------------------------------------
//
//  RequestError.swift
//
//  @likils <likils@icloud.com>
//  Copyright (c) 2022. All rights reserved.
//
// ----------------------------------------------------------------------------

import Foundation

// ----------------------------------------------------------------------------

public enum RequestError: Error {

    case dataTaskBadResponse(URLResponse?)
    case dataTaskError(Error)

    case serializationError(Error)
}
