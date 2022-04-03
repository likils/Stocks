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

    // MARK: - Methods

    func get(forKey key: Key) -> Value? {
        return self[key]
    }

    func getAll() -> [Key: Value] {
        return [:]
    }

    func put(_ value: Value, forKey key: Key) {
        self[key] = value
    }

    func remove(forKey key: Key) -> Value? {

        let value = self[key]
        self[key] = nil

        return value
    }

    func removeAll() {
        self.cache.removeAllObjects()
    }

    nonisolated func eraseToAnyStorage() -> AnyStorage<Key, Value> {
        return AnyStorage(storage: self)
    }

    // MARK: - Private Methods

    private subscript(key: Key) -> Value? {
        get {
            let wrappedKey = WrappedKey(key)
            return self.cache.object(forKey: wrappedKey)?.value
        }
        set {
            let wrappedKey = WrappedKey(key)

            if let value = newValue {
                self.cache.setObject(WrappedValue(value), forKey: wrappedKey)
            }
            else {
                self.cache.removeObject(forKey: wrappedKey)
            }
        }
    }

    // MARK: - Inner Types

    private final class WrappedKey: NSObject {

        let key: Key

        override var hash: Int {
            self.key.hashValue
        }

        init(_ key: Key) {
            self.key = key
        }

        override func isEqual(_ object: Any?) -> Bool {
            let wrappedKey = object as? Self
            return (wrappedKey?.key == self.key)
        }
    }

    private final class WrappedValue {

        let value: Value

        init(_ value: Value) {
            self.value = value
        }
    }
}
