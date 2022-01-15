// ----------------------------------------------------------------------------
//
//  ImageRequestFactory.swift
//
//  @likils <likils@icloud.com>
//  Copyright (c) 2022. All rights reserved.
//
// ----------------------------------------------------------------------------

import UIKit

// ----------------------------------------------------------------------------

public enum ImageRequestFactory {

// MARK: - Private properties

    private static let cachedImageRepository: ImageRepository = {
        let cacheStorage = CacheStorage<URL, UIImage>()
        return ImageRepositoryImpl(storage: cacheStorage.eraseToAnyStorage())
    }()

// MARK: - Methods

    public static func createRequest(imageLink: URL, imageSize: CGFloat? = nil) -> ImageRequest {
        return ImageRequest(cachedImageRepository: cachedImageRepository, imageLink: imageLink, imageSize: imageSize)
    }
}
