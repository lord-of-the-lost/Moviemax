//
//  ImageCacheService.swift
//  Moviemax
//
//  Created by Николай Игнатов on 05.04.2025.
//

import Foundation

final class ImageCacheService {
    private let cache = NSCache<NSURL, NSData>()
    
    init() {
        cache.totalCostLimit = 200 * 1024 * 1024 // 200 MB
    }
    
    func cacheImage(_ data: Data, for url: URL) {
        cache.setObject(data as NSData, forKey: url as NSURL)
    }
    
    func getImageFromCache(for url: URL) -> Data? {
        return cache.object(forKey: url as NSURL) as Data?
    }
    
    func clearCache() {
        cache.removeAllObjects()
    }
}
