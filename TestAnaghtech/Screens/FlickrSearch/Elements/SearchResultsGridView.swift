//
//  SearchResultsGridView.swift
//  TestAnaghtech
//
//  Created by Vladislav Murygin on 2/12/25.
//

import SwiftUI


struct SearchResultsGridView: View {
    
    let items: [FlickrItem]
    let columns: [GridItem]
    
    @State private var selectedItem: FlickrItem?
    @State private var showingOptions = false
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 5) {
                ForEach(items) { item in
                    CachedImageView(url: item.media.m)
                        .aspectRatio(1, contentMode: .fill)
                        .frame(width: UIScreen.main.bounds.width / 3 - 10, height: 100)
                        .clipped()
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .shadow(radius: 2)
                        .onTapGesture {
                            selectedItem = item
                            showingOptions = true
                        }
                }
            }
            .padding(.horizontal, 5)
        }
        .confirmationDialog("Open Image", isPresented: $showingOptions, presenting: selectedItem) { item in
            NavigationLink("Open native") {
                FlickrDetailView(item: item)
            }
            
            NavigationLink("Open in HTML") {
                AttributedText(.html(withBody: item.description))
            }
        
            Button("Cancel", role: .cancel) {}
        } message: { item in
            Text("Choose how to open \(item.title)")
        }
    }
}


