// ----------------------------------------------------------------------------
//
//  ImageRequest.swift
//
//  @likils <likils@icloud.com>
//  Copyright (c) 2022. All rights reserved.
//
// ----------------------------------------------------------------------------

import StocksPersistence
import UIKit

// ----------------------------------------------------------------------------

public final class ImageRequest: AbstractRequest<Data> {

    // MARK: - Private Properties

    private let cachedImageRepository: ImageRepository
    private let imageLink: URL
    private let imageSize: CGFloat?

    // MARK: - Construction

    init(cachedImageRepository: ImageRepository, imageLink: URL, imageSize: CGFloat) {
        self.cachedImageRepository = cachedImageRepository
        self.imageLink = imageLink
        self.imageSize = (imageSize == .zero) ? nil : imageSize

        let urlRequest = URLRequest(url: imageLink)

        let requestTask = RequestDataTask(urlRequest: urlRequest)
        super.init(requestTask.eraseToAnyRequestTask())
    }

    // MARK: - Methods

    public func prepareImage() async -> UIImage? {
        return await requestImage()
    }

    // MARK: - Private Methods

    private func requestImage() async -> UIImage? {
        var image: UIImage?

        if let cachedImage = await self.cachedImageRepository.getImage(forKey: self.imageLink) {
            image = cachedImage
        }
        else if let imageData = try? await execute(),
                let createdImage = createImage(from: imageData, with: self.imageSize) {

            self.cachedImageRepository.putImage(createdImage, forKey: self.imageLink)
            image = createdImage
        }

        return image
    }

    private func createImage(from imageData: Data, with imageSize: CGFloat?) -> UIImage? {

        let image = imageSize.map { size in
            createDownsampledImage(from: imageData, with: size)
        }

        return image ?? UIImage(data: imageData)
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


        var image: UIImage?

        if let imageSource = CGImageSourceCreateWithData(imageData as CFData, imageSourceOptions),
           let downsampledImage = CGImageSourceCreateThumbnailAtIndex(imageSource, 0, downsampleOptions) {

            image = UIImage(cgImage: downsampledImage)
        }

        return image
    }
}
