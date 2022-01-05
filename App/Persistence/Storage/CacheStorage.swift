// ----------------------------------------------------------------------------
//
//  CacheStorage.swift
//
//  @likils <likils@icloud.com>
//  Copyright (c) 2022. All rights reserved.
//
// ----------------------------------------------------------------------------

import Foundation

// ----------------------------------------------------------------------------

actor CacheStorage<Key: Hashable, Value>: Storage {

// MARK: - Private Properties

    private var cache = NSCache<WrappedKey, WrappedValue>()
    private nonisolated lazy var anyStorage = AnyStorage(storage: self)

// MARK: - Methods

    subscript(key: Key) -> Value? {
        get {
            let wrappedKey = WrappedKey(key)
            return cache.object(forKey: wrappedKey)?.value
        }
        set {
            let wrappedKey = WrappedKey(key)

            if let value = newValue {
                cache.setObject(WrappedValue(value), forKey: wrappedKey)
            }
            else {
                cache.removeObject(forKey: wrappedKey)
            }
        }
    }

    func get(forKey key: Key) async -> Value? {
        return self[key]
    }

    func getAll() async -> [Key: Value] {
        return [:]
    }

    func put(_ value: Value, forKey key: Key) async {
        self[key] = value
    }

    func remove(forKey key: Key) async -> Value? {

        let value = self[key]
        self[key] = nil

        return value
    }

    func removeAll() async {
        cache.removeAllObjects()
    }

    nonisolated func eraseToAnyStorage() -> AnyStorage<Key, Value> {
        return anyStorage
    }

// MARK: - Internal Types

    private final class WrappedKey: NSObject {

        init(_ key: Key) {
            self.key = key
        }

        let key: Key

        override var hash: Int {
            key.hashValue
        }

        override func isEqual(_ object: Any?) -> Bool {
            let wrappedKey = object as? Self
            return (wrappedKey?.key == key)
        }
    }

    private final class WrappedValue {

        init(_ value: Value) {
            self.value = value
        }

        let value: Value
    }
}
