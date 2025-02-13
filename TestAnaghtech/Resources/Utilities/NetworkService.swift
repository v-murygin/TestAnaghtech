//
//  NetworkService.swift
//  TestAnaghtech
//
//  Created by Vladislav Murygin on 2/12/25.
//

import Foundation
import UIKit


@Observable
final class NetworkService: NetworkServiceProtocol {
    
    private enum Constants {
        static let baseURL = "https://api.flickr.com/services/feeds/photos_public.gne"
    }
    
    private let cache: CacheManager
    
    init(cache: CacheManager = .shared) {
        self.cache = cache
    }
    
    func searchPhotos<T: Decodable>(query: String) async throws -> T {
        var urlComponents = URLComponents(string: Constants.baseURL)
        
        urlComponents?.queryItems = [
            URLQueryItem(name: "format", value: "json"),
            URLQueryItem(name: "nojsoncallback", value: "1"),
            URLQueryItem(name: "tags", value: query)
        ]
        
        guard let url = urlComponents?.url else {
            throw NetworkError.invalidURL
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }
        
        guard (200...299).contains(httpResponse.statusCode) else {
            throw NetworkError.serverError(httpResponse.statusCode)
        }
        
        do {
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            return try decoder.decode(T.self, from: data)
        } catch {
            throw NetworkError.decodingError
        }
    }
    
    func loadImage(from urlString: String) async throws -> UIImage {
        if let cachedImage = await cache.get(for: urlString) {
            return cachedImage
        }
        
        guard let url = URL(string: urlString) else {
            throw NetworkError.invalidURL
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }
        
        guard (200...299).contains(httpResponse.statusCode) else {
            throw NetworkError.serverError(httpResponse.statusCode)
        }
        
        guard let image = UIImage(data: data) else {
            throw NetworkError.invalidImageData
        }
        
        await cache.insert(image, for: urlString)
        return image
    }
}
