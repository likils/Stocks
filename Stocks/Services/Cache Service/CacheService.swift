//
//  Cache Service.swift
//  Stocks
//
//  Created by likils on 29.04.2021.
//

import UIKit

protocol CacheService {
    
    func fetchImage(from url: URL, withSize size: Float, completion: @escaping (UIImage) -> Void)
    
}

class CacheServiceImpl: CacheService {
    
    // MARK: - Private properties
    private var nsCache = NSCache<NSURL, UIImage>()
    
    // MARK: - Public methods
    func fetchImage(from url: URL, withSize size: Float, completion: @escaping (UIImage) -> Void) {
        if let image = nsCache.object(forKey: url as NSURL) {
            completion(image)
        } else {
            DispatchQueue.global(qos: .userInitiated).async { [weak self] in
                if let image = self?.downsampleImage(at: url, with: CGFloat(size)) {
                    self?.nsCache.setObject(image, forKey: url as NSURL)
                    completion(image)
                }
            }
        }
    }
    
    // MARK: - Private methods
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
