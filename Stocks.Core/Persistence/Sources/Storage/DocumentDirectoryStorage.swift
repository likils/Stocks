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

    // MARK: - Private Properties

    private let documentName: String
    private lazy var temporaryStorage: [Key: Value] = loadFromDocumentDirectory()

    // MARK: - Construction

    init(documentName: String) {
        self.documentName = documentName
    }

    // MARK: - Methods

    func get(forKey key: Key) -> Value? {
        return self.temporaryStorage[key]
    }

    func getAll() -> [Key : Value] {
        return self.temporaryStorage
    }

    func put(_ value: Value, forKey key: Key) {
        self.temporaryStorage[key] = value
        saveToDocumentDirectory()
    }

    func remove(forKey key: Key) -> Value? {

        let value = self.temporaryStorage[key]

        self.temporaryStorage[key] = nil
        saveToDocumentDirectory()

        return value
    }

    func removeAll() {
        self.temporaryStorage.removeAll()
        saveToDocumentDirectory()
    }

    nonisolated func eraseToAnyStorage() -> AnyStorage<Key, Value> {
        return AnyStorage(storage: self)
    }

    // MARK: - Private Methods

    private func getDocumentDirectoryPath() throws -> URL {
        return try FileManager.default.url(
            for: .documentDirectory,
            in: .userDomainMask,
            appropriateFor: nil,
            create: false
        )
        .appendingPathComponent("\(documentName)")
        .appendingPathExtension("json")
    }

    private func saveToDocumentDirectory() {
        do {
            let path = try getDocumentDirectoryPath()
            let data = try JSONEncoder().encode(self.temporaryStorage)
            try data.write(to: path)
        }
        catch {
            // TODO: Add Logger
            print("saveToDocumentDirectory FAILED:", error)
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
            print("loadFromDocumentDirectory FAILED:", error)
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
            print("removeFromDocumentDirectory FAILED:", error)
        }
    }
}
