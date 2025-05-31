//
//  PhotoCacheViewModel.swift
//  TakeHomeProjectFetch
//
//  Created by Ricardo Garza on 5/29/25.
//

import SwiftUI
import Combine

actor PhotoCacheViewModel {
    private var memoryCache = NSCache<NSString, UIImage>()
    private let fileManager = FileManager.default
    private let cacheDirectory: URL
    
    init() {
        let documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        cacheDirectory = documentsDirectory.appendingPathComponent("ImageCache")
        
        try? fileManager.createDirectory(at: cacheDirectory, withIntermediateDirectories: true)
        memoryCache.countLimit = 100
        memoryCache.totalCostLimit = 50 * 1024 * 1024
    }
    
    private func getCacheFilePath(for key: String) -> URL {
        return cacheDirectory.appendingPathComponent(key.addingPercentEncoding(withAllowedCharacters: .alphanumerics) ?? key)
    }
    
    func image(forKey key: String) async -> UIImage? {
        if let cachedImage = memoryCache.object(forKey: key as NSString) {
            return cachedImage
        }
        let fileURL = getCacheFilePath(for: key)
        guard let data = try? Data(contentsOf: fileURL),
              let image = UIImage(data: data) else {
            return nil
        }
        memoryCache.setObject(image, forKey: key as NSString)
        return image
    }
    
    func setImage(_ image: UIImage, forKey key: String) async {
        memoryCache.setObject(image, forKey: key as NSString)
        
        let fileURL = getCacheFilePath(for: key)
        if let data = image.jpegData(compressionQuality: 0.8) {
            try? data.write(to: fileURL)
        }
    }
    
    func clearCache() async {
        memoryCache.removeAllObjects()
        try? fileManager.removeItem(at: cacheDirectory)
        try? fileManager.createDirectory(at: cacheDirectory, withIntermediateDirectories: true)
    }
}

extension View {
    func loadImage(from url: URL, cache: PhotoCacheViewModel) async -> UIImage? {
        if let cachedImage = await cache.image(forKey: url.absoluteString) {
            return cachedImage
        }
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            if let image = UIImage(data: data) {
                await cache.setImage(image, forKey: url.absoluteString)
                return image
            }
        } catch {
            print("Failed to load image: \(error)")
        }
        return nil
    }
}

