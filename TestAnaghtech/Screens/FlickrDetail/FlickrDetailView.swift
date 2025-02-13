//
//  FlickrDetailView.swift
//  TestAnaghtech
//
//  Created by Vladislav Murygin on 2/12/25.
//

import SwiftUI

struct FlickrDetailView: View {
    
    @Environment(\.dismiss) private var dismiss
    
    let item: FlickrItem
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                CachedImageView(url: item.media.m)
                    .aspectRatio(contentMode: .fit)
                    .frame(maxWidth: .infinity)
                
                VStack(alignment: .leading, spacing: 8) {
                    if !item.title.isEmpty {
                        Text(item.title)
                            .font(.title)
                    }
                    
                    
                    if !item.cleanDescription.isEmpty {
                        Text(item.cleanDescription)
                            .font(.body)
                    }
                    
                    Text("By \(item.cleanAuthor)")
                        .font(.subheadline)
                    
                    Text("Published: \(formatDate(item.published))")
                        .font(.caption)
                    
                    if let size = item.imageSize {
                        Text("Size: \(size.width)x\(size.height)")
                            .font(.caption)
                    }
                }
                .padding()
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                ShareLink(item: item.link)
            }
        }
    }
    
    private func formatDate(_ dateString: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        
        guard let date = formatter.date(from: dateString) else {
            return dateString
        }
        
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}

