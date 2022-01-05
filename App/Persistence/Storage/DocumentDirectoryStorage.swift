// ----------------------------------------------------------------------------
//
//  DocumentDirectoryStorage.swift
//
//  @likils <likils@icloud.com>
//  Copyright (c) 2022. All rights reserved.
//
// ----------------------------------------------------------------------------

import Foundation

// ----------------------------------------------------------------------------

actor DocumentDirectoryStorage<Key: Hashable, Value>: Storage where Key: Codable, Value: Codable {

// MARK: - Construction

    init(directoryName: String) {
        self.directoryName = directoryName
    }

// MARK: - Private Properties

    private let directoryName: String
    private lazy var temporaryStorage: [Key: Value] = loadFromDocumentDirectory()
    private nonisolated lazy var anyStorage = AnyStorage(storage: self)

// MARK: - Methods

    func get(forKey key: Key) async -> Value? {
        return temporaryStorage[key]
    }

    func getAll() async -> [Key : Value] {
        return temporaryStorage
    }

    func put(_ value: Value, forKey key: Key) async {
        temporaryStorage[key] = value
        saveToDocumentDirectory()
    }

    func remove(forKey key: Key) async -> Value? {

        let value = temporaryStorage[key]

        temporaryStorage[key] = nil
        saveToDocumentDirectory()

        return value
    }

    func removeAll() async {
        temporaryStorage.removeAll()
        removeFromDocumentDirectory()
    }

    nonisolated func eraseToAnyStorage() -> AnyStorage<Key, Value> {
        return anyStorage
    }

// MARK: - Private Methods

    private func getDocumentDirectoryPath() throws -> URL {
        return try FileManager.default.url(
            for: .documentDirectory,
            in: .userDomainMask,
            appropriateFor: nil,
            create: false
        )
        .appendingPathComponent("\(directoryName)")
        .appendingPathExtension("json")
    }

    private func saveToDocumentDirectory() {
        do {
            let path = try getDocumentDirectoryPath()
            let data = try JSONEncoder().encode(temporaryStorage)
            try data.write(to: path)
        }
        catch {
            // TODO: Add Logger
        }
    }

    private func loadFromDocumentDirectory() -> [Key: Value] {
        do {
            let path = try getDocumentDirectoryPath()
            let data = try Data(contentsOf: path)
            return try JSONDecoder().decode([Key: Value].self, from: data)
        }
        catch {
            // TODO: Add Logger
            return [:]
        }
    }

    private func removeFromDocumentDirectory() {
        do {
            let path = try getDocumentDirectoryPath()
            try FileManager.default.removeItem(at: path)
        }
        catch {
            // TODO: Add Logger
        }
    }
}
