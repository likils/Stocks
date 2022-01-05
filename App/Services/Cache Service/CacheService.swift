//
//  Cache Service.swift
//  Stocks
//
//  Created by likils on 29.04.2021.
//

import UIKit

protocol CacheService {
    
    func fetchImage(from url: URL, withSize size: Double, completion: @escaping (UIImage) -> Void)
    
}

class CacheServiceImpl: CacheService {
    
    // MARK: - Private properties
    private let imageRepository: ImageRepository = {
        let cacheStorage = CacheStorage<URL, UIImage>()
        let cacheImageRepository = ImageRepositoryImpl(storage: cacheStorage.eraseToAnyStorage())
        return cacheImageRepository
    }()
    
    // MARK: - Public Methods
    func fetchImage(from url: URL, withSize size: Double, completion: @escaping (UIImage) -> Void) {
        Task {
            if let image = await imageRepository.getImage(forKey: url) {
                completion(image)
            } else {
                if let image = downsampleImage(at: url, with: CGFloat(size)) {
                    imageRepository.putImage(image, forKey: url)
                    completion(image)
                }
            }
        }
    }
    
    // MARK: - Private Methods
    private func downsampleImage(at imageURL: URL, with maxImageSize: CGFloat) -> UIImage? {
        
// used from https://swiftsenpai.com/development/reduce-uiimage-memory-footprint/
        
        // Create an CGImageSource that represent an image
        let imageSourceOptions = [kCGImageSourceShouldCache: false] as CFDictionary
        guard let imageSource = CGImageSourceCreateWithURL(imageURL as CFURL, imageSourceOptions) else {
            return nil
        }
        
        // Calculate the desired dimension
        let dimensionInPixels = maxImageSize * UIScreen.main.scale
        
        // Perform downsampling
        let downsampleOptions = [
            kCGImageSourceCreateThumbnailFromImageAlways: true,
            kCGImageSourceShouldCacheImmediately: true,
            kCGImageSourceCreateThumbnailWithTransform: true,
            kCGImageSourceThumbnailMaxPixelSize: dimensionInPixels
        ] as CFDictionary
        
        guard let downsampledImage = CGImageSourceCreateThumbnailAtIndex(imageSource, 0, downsampleOptions) else {
            return nil
        }
        
        return UIImage(cgImage: downsampledImage)
    }
    
}
