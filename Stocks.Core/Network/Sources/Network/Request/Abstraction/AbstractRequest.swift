// ----------------------------------------------------------------------------
//
//  AbstractRequest.swift
//
//  @likils <likils@icloud.com>
//  Copyright (c) 2022. All rights reserved.
//
// ----------------------------------------------------------------------------

public class AbstractRequest<Value>: Request where Value: Codable {

    // MARK: - Private Properties

    private let requestTask: AnyRequestTask<Value>

    // MARK: - Construction

    init(_ requestTask: AnyRequestTask<Value>) {
        self.requestTask = requestTask
    }

    // MARK: - Methods

    public func execute() async throws -> Value {
        try await self.requestTask.execute()
    }
}
