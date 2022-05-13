//
//  CacheManager.swift
//  APOD
//
//  Created by Михаил Мезенцев on 09.01.2022.
//

import UIKit

class CacheManager {
    
    static let shared = CacheManager()
    
    private init() {}
    
    func getImage(with url: String, completion: @escaping (Data) -> Void) -> Cancellable? {
        guard let imageUrl = URL(string: url) else { return nil }
        
        if let cachedImageData = getFromCache(with: imageUrl) {
            completion(cachedImageData)
        } else {
            let imageRequest = Networker.shared.fetchImage(with: imageUrl) {
                [weak self] data, response in
                
                DispatchQueue.main.async {
                    completion(data)
                }
                
                self?.saveToCache(data, and: response)
            }
            
            return imageRequest
        }
        
        return nil
    }
    
    private func saveToCache(_ data: Data, and response: URLResponse) {
        guard let url = response.url else { return }
        let request = URLRequest(url: url)
        let cachedResponse = CachedURLResponse(response: response, data: data)
        URLCache.shared.storeCachedResponse(cachedResponse, for: request)
    }
    
    private func getFromCache(with url: URL) -> Data? {
        let request = URLRequest(url: url)
        if let cachedResponse = URLCache.shared.cachedResponse(for: request) {
            return cachedResponse.data
        }
        return nil
    }
}
