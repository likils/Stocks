// ----------------------------------------------------------------------------
//
//  RequestResult.swift
//
//  @likils <likils@icloud.com>
//  Copyright (c) 2022. All rights reserved.
//
// ----------------------------------------------------------------------------

public typealias RequestResult<Value> = Result<Value, RequestError>

public typealias RequestCompletion<Value> = (RequestResult<Value>) -> Void
