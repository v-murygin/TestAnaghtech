//
//  CachedImageView.swift
//  TestAnaghtech
//
//  Created by Vladislav Murygin on 2/13/25.
//

import SwiftUI

struct CachedImageView: View {
    
    @Environment(\.networkService) private var networkService
    
    @State private var image: UIImage?
    @State private var isLoading = false
    
    let url: String
    
    init(url: String) {
        self.url = url
    }
    
    var body: some View {
        Group {
            if let image = image {
                Image(uiImage: image)
                    .resizable()
            } else {
                ProgressView()
            }
        }
        .task(id: url) {
            guard !isLoading else { return }
            isLoading = true
            defer { isLoading = false }
            
            do {
                let newimage = try await networkService.loadImage(from: url)
                await MainActor.run { image = newimage }
            } catch {
                switch error {
                case let urlError as URLError where urlError.code == .cancelled:
                    return
                default:
                    print("❌ Failed to load image: \(error.localizedDescription)")
                }
            }
        }
    }
}
