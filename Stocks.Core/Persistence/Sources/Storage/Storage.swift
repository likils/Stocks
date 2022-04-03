// ----------------------------------------------------------------------------
//
//  Storage.swift
//
//  @likils <likils@icloud.com>
//  Copyright (c) 2022. All rights reserved.
//
// ----------------------------------------------------------------------------

protocol Storage {

    associatedtype Key: Hashable
    associatedtype Value

    // MARK: - Methods

    func get(forKey: Key) async -> Value?

    func getAll() async -> [Key: Value]

    func put(_ value: Value, forKey: Key) async

    func remove(forKey: Key) async -> Value?

    func removeAll() async
}
