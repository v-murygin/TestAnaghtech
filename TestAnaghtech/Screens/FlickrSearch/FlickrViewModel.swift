//
//  FlickrViewModel.swift
//  TestAnaghtech
//
//  Created by Vladislav Murygin on 2/12/25.
//

import Foundation
import Combine

@Observable
final class FlickrViewModel {
    
    private(set) var items: [FlickrItem] = []
    private(set) var isLoading = false
    
    private var networkService: NetworkServiceProtocol?
   
    var showError = false
    var errorMessage: String?
    
    var hasResults: Bool {
        !items.isEmpty
    }
    
    func setup(networkService: NetworkServiceProtocol) {
        self.networkService = networkService
    }
    
    func search(for query: String) async throws {
        guard !isLoading, !query.isEmpty else {
            items = []
            return
        }
        
        isLoading = true
        
        try? await Task.sleep(for: .milliseconds(500))
        
        defer { isLoading = false }
        
        guard let feed: FlickrFeed = try await networkService?.searchPhotos(query: query) else {
            throw NetworkError.invalidResponse
        }
        
        await MainActor.run {
            self.items = feed.items
        }
    }
    
    @MainActor
    func handleError(_ error: Error) {
         switch error {
         case is CancellationError:
             print("🛑 Task cancelled - ignoring CancellationError")
             return
         case let urlError as URLError where urlError.code == .cancelled:
             print("🛑 Network request cancelled - ignoring URLError.cancelled")
             return
             
         default:
             print("❌ Unexpected error: \(error.localizedDescription) [Type: \(type(of: error))]")
             errorMessage = error.localizedDescription
             showError = true
         }
     }
}

