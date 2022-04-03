// ----------------------------------------------------------------------------
//
//  AnyStorage.swift
//
//  @likils <likils@icloud.com>
//  Copyright (c) 2022. All rights reserved.
//
// ----------------------------------------------------------------------------

struct AnyStorage<Key: Hashable, Value>: Storage {

    // MARK: - Private Properties

    private let _storage: AnyObject
    private let _get: (Key) async -> Value?
    private let _getAll: () async -> [Key: Value]
    private let _put: (Value, Key) async -> Void
    private let _remove: (Key) async -> Value?
    private let _removeAll: () async -> Void

    // MARK: - Construction

    init<S: Storage>(storage: S) where S.Key == Key, S.Value == Value {
        _storage = storage as AnyObject
        _get = storage.get
        _getAll = storage.getAll
        _put = storage.put
        _remove = storage.remove
        _removeAll = storage.removeAll
    }

    // MARK: - Methods

    func get(forKey: Key) async -> Value? {
        await _get(forKey)
    }

    func getAll() async -> [Key: Value] {
        await _getAll()
    }

    func put(_ value: Value, forKey: Key) async {
        await _put(value, forKey)
    }

    func remove(forKey: Key) async -> Value? {
        await _remove(forKey)
    }

    func removeAll() async {
        await _removeAll()
    }
}
