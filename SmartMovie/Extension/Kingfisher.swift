//
//  Kingfisher.swift
//  SmartMovie
//
//  Created by Nguyễn Đình Kiên on 04/04/2023.
//
import Foundation
import UIKit
import Kingfisher

final class ImageCache {
    static let shared = ImageCache()

    let cache = Kingfisher.ImageCache.default
    let options: KingfisherOptionsInfo = [.transition(.fade(0.2)),
                                          .cacheOriginalImage, .forceTransition,
                                          .processor(DefaultImageProcessor.default),
                                          .memoryCacheExpiration(.seconds(60))]

    private init() {
        cache.memoryStorage.config.totalCostLimit = 100 * 1024 * 1024 // 100 MB
                cache.diskStorage.config.sizeLimit = 500 * 1024 * 1024 // 500 MB
    }
}
