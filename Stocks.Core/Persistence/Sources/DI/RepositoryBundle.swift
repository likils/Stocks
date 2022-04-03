// ----------------------------------------------------------------------------
//
//  RepositoryBundle.swift
//
//  @likils <likils@icloud.com>
//  Copyright (c) 2021. All rights reserved.
//
// ----------------------------------------------------------------------------

import Resolver
import StocksData
import UIKit

// ----------------------------------------------------------------------------

extension Resolver {

    // MARK: - Methods

    public static func registerRepositories() {

        register(CompanyProfileRepository.self) {

            let documentDirectoryStorage = createDocumentDirectoryStorage(
                repositoryType: CompanyProfileRepository.self,
                keyType: String.self,
                valueType: [CompanyProfileResponseModel].self
            )

            return CompanyProfileRepositoryImpl(storage: documentDirectoryStorage)
        }
        .scope(.shared)

        register(ImageRepository.self) {
            let cacheStorage = createCacheStorage(keyType: URL.self, valueType: UIImage.self)
            return ImageRepositoryImpl(storage: cacheStorage)
        }
        .scope(.shared)
    }

    // MARK: - Private Methods

    private static func createCacheStorage<Key: Hashable, Value>(
        keyType: Key.Type,
        valueType: Value.Type
    ) -> AnyStorage<Key, Value> {

        return CacheStorage<Key, Value>().eraseToAnyStorage()
    }

    private static func createDocumentDirectoryStorage<Repository, Key: Hashable & Codable, Value: Codable>(
        repositoryType: Repository.Type,
        keyType: Key.Type,
        valueType: Value.Type
    ) -> AnyStorage<Key, Value> {

        return DocumentDirectoryStorage<Key, Value>(documentName: "\(repositoryType.self)").eraseToAnyStorage()
    }
}
