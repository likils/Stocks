// ----------------------------------------------------------------------------
//
//  ImageRequestFactory.swift
//
//  @likils <likils@icloud.com>
//  Copyright (c) 2022. All rights reserved.
//
// ----------------------------------------------------------------------------

import Foundation
import StocksPersistence

// ----------------------------------------------------------------------------

public final class ImageRequestFactory {

    // MARK: - Private Properties

    private let cachedImageRepository: ImageRepository

    // MARK: - Construction

    init(cachedImageRepository: ImageRepository) {
        self.cachedImageRepository = cachedImageRepository
    }

    // MARK: - Methods

    public func createRequest(imageLink: URL, imageSize: Double = 0) -> ImageRequest {
        return ImageRequest(cachedImageRepository: self.cachedImageRepository, imageLink: imageLink, imageSize: imageSize)
    }
}
