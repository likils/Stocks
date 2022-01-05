// ----------------------------------------------------------------------------
//
//  ImageRepositoryImpl.swift
//
//  @likils <likils@icloud.com>
//  Copyright (c) 2022. All rights reserved.
//
// ----------------------------------------------------------------------------

import UIKit

// ----------------------------------------------------------------------------

final class ImageRepositoryImpl: ImageRepository {

// MARK: - Construction

    init(storage: AnyStorage<URL, UIImage>) {
        self.storage = storage
    }

// MARK: - Private Properties

    private let storage: AnyStorage<URL, UIImage>

// MARK: - Methods

    func getImage(forKey key: URL) async -> UIImage? {
        await storage.get(forKey: key)
    }

    func putImage(_ image: UIImage, forKey key: URL) async {
        await storage.put(image, forKey: key)
    }

    func removeImage(forKey key: URL) async -> UIImage? {
        await storage.remove(forKey: key)
    }

    func removeAll() async {
        await storage.removeAll()
    }
}
