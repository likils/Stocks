// ----------------------------------------------------------------------------
//
//  ImageRepository.swift
//
//  @likils <likils@icloud.com>
//  Copyright (c) 2022. All rights reserved.
//
// ----------------------------------------------------------------------------

import UIKit

// ----------------------------------------------------------------------------

public protocol ImageRepository: AnyObject {

    // MARK: - Methods

    func getImage(forKey: URL) async -> UIImage?

    func putImage(_ image: UIImage, forKey: URL)

    func removeImage(forKey: URL)

    func removeAll()
}
