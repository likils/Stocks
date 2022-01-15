// ----------------------------------------------------------------------------
//
//  ImageRequest.swift
//
//  @likils <likils@icloud.com>
//  Copyright (c) 2022. All rights reserved.
//
// ----------------------------------------------------------------------------

import Combine
import UIKit

// ----------------------------------------------------------------------------

public typealias ImagePublisher = AnyPublisher<UIImage, Never>

// ----------------------------------------------------------------------------

public final class ImageRequest: AbstractRequest<Data> {

// MARK: - Private Properties

    private let cachedImageRepository: ImageRepository
    private let imageLink: URL
    private let imageSize: CGFloat?
    private var imagePublisher = PassthroughSubject<UIImage?, Never>()

// MARK: - Construction

    init(cachedImageRepository: ImageRepository, imageLink: URL, imageSize: CGFloat?) {
        self.cachedImageRepository = cachedImageRepository
        self.imageLink = imageLink
        self.imageSize = imageSize

        let urlRequest = URLRequest(url: imageLink)

        let requestTask = RequestDataTask(urlRequest: urlRequest)
        super.init(requestTask.eraseToAnyRequestTask())
    }

// MARK: - Methods

    public func prepareImage() -> ImagePublisher {
        Task {
            await requestImage()
        }

        return imagePublisher
            .compactMap { $0 }
            .flatMap { Just($0) }
            .eraseToAnyPublisher()
    }

// MARK: - Private Methods

    private func requestImage() async {

        if let cachedImage = await cachedImageRepository.getImage(forKey: imageLink) {
            imagePublisher.send(cachedImage)
        }
        else if let imageData = try? await execute(),
                let image = createImage(from: imageData, with: imageSize) {

            cachedImageRepository.putImage(image, forKey: imageLink)
            imagePublisher.send(image)
        }
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
