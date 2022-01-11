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

    private static let cacheImageRepository: ImageRepository = {
        let cacheStorage = CacheStorage<URL, UIImage>()
        let cacheImageRepository = ImageRepositoryImpl(storage: cacheStorage.eraseToAnyStorage())
        return cacheImageRepository
    }()

// MARK: - Methods

    public static func createRequest(imageLink: URL, imageSize: CGFloat? = nil) -> ImageRequest {
        return ImageRequest(cacheImageRepository: cacheImageRepository, imageLink: imageLink, imageSize: imageSize)
    }
}
