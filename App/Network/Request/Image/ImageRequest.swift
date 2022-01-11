// ----------------------------------------------------------------------------
//
//  ImageRequest.swift
//
//  @likils <likils@icloud.com>
//  Copyright (c) 2022. All rights reserved.
//
// ----------------------------------------------------------------------------

import UIKit

// ----------------------------------------------------------------------------

public final class ImageRequest: AbstractRequest<Data> {

// MARK: - Private Properties

    private let cacheImageRepository: ImageRepository
    private let imageLink: URL
    private let imageSize: CGFloat?

// MARK: - Construction

    init(cacheImageRepository: ImageRepository, imageLink: URL, imageSize: CGFloat?) {
        self.cacheImageRepository = cacheImageRepository
        self.imageLink = imageLink
        self.imageSize = imageSize

        let urlRequest = URLRequest(url: imageLink)

        let requestTask = RequestDataTask(urlRequest: urlRequest)
        super.init(requestTask.eraseToAnyRequestTask())
    }

// MARK: - Methods

    public func execute() async throws -> UIImage {
        let image: UIImage

        if let cachedImage = await cacheImageRepository.getImage(forKey: imageLink) {
            image = cachedImage
        }
        else {
            let imageData = try await super.execute()
            image = try createImage(from: imageData, with: imageSize)

            cacheImageRepository.putImage(image, forKey: imageLink)
        }

        return image
    }

// MARK: - Private Methods

    private func createImage(from imageData: Data, with imageSize: CGFloat?) throws -> UIImage {

        if let imageSize = imageSize,
           let image = createDownsampledImage(from: imageData, with: imageSize) ?? UIImage(data: imageData) {

            return image
        }
        else if let image = UIImage(data: imageData) {
            return image
        }
        else {
            throw NetworkError.imageConversionError(imageLink.absoluteString)
        }
    }

    // used from https://swiftsenpai.com/development/reduce-uiimage-memory-footprint/
    private func createDownsampledImage(from imageData: Data, with imageSize: CGFloat) -> UIImage? {

        let imageSourceOptions = [kCGImageSourceShouldCache: false] as CFDictionary
        let dimensionInPixels = imageSize * UIScreen.main.scale

        let downsampleOptions = [
            kCGImageSourceCreateThumbnailFromImageAlways: true,
            kCGImageSourceShouldCacheImmediately: true,
            kCGImageSourceCreateThumbnailWithTransform: true,
            kCGImageSourceThumbnailMaxPixelSize: dimensionInPixels
        ] as CFDictionary


        if let imageSource = CGImageSourceCreateWithData(imageData as CFData, imageSourceOptions),
           let downsampledImage = CGImageSourceCreateThumbnailAtIndex(imageSource, 0, downsampleOptions) {

            return UIImage(cgImage: downsampledImage)
        }
        else {
            return nil
        }
    }
}
