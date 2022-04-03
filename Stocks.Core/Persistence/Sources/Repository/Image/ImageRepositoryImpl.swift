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

    // MARK: - Private Properties

    private let storage: AnyStorage<URL, UIImage>

    // MARK: - Construction

    init(storage: AnyStorage<URL, UIImage>) {
        self.storage = storage
    }

    // MARK: - Methods

    func getImage(forKey key: URL) async -> UIImage? {
        await self.storage.get(forKey: key)
    }

    func putImage(_ image: UIImage, forKey key: URL) {
        Task {
            await self.storage.put(image, forKey: key)
        }
    }

    func removeImage(forKey key: URL) {
        Task {
            await self.storage.remove(forKey: key)
        }
    }

    func removeAll() {
        Task {
            await self.storage.removeAll()
        }
    }
}
