//
//  FlickrViewModel.swift
//  TestAnaghtech
//
//  Created by Vladislav Murygin on 2/12/25.
//

import Foundation

@Observable
final class FlickrViewModel {
    
    private(set) var items: [FlickrItem] = []
    private(set) var isLoading = false
    
    private let networkService: NetworkServiceProtocol
    
    var hasResults: Bool {
        !items.isEmpty
    }
    
    init(networkService: NetworkServiceProtocol = NetworkService()) {
        self.networkService = networkService
    }
    
    func search(for query: String) async throws {
        guard !query.isEmpty else {
            items = []
            return
        }
        
        isLoading = true
        defer { isLoading = false }

        do {
            let feed: FlickrFeed = try await networkService.searchPhotos(query: query)
            
            guard !Task.isCancelled else { return }
            
            await MainActor.run {
                self.items = feed.items
            }
            
        } catch {
            if Task.isCancelled { return }
            throw error 
        }
    }
}
