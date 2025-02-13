//
//  FlickrSearchView.swift
//  TestAnaghtech
//
//  Created by Vladislav Murygin on 2/12/25.
//

import SwiftUI

struct FlickrSearchView: View {
    
    @State private var viewModel = FlickrViewModel()
    @State private var searchText = ""
    @State private var errorMessage: String?
    @State private var showError = false
    
    private let columns = [
        GridItem(.flexible(), spacing: 5),
        GridItem(.flexible(), spacing: 5),
        GridItem(.flexible(), spacing: 5)
    ]
    
    var body: some View {
        NavigationStack {
            Group {
                if viewModel.hasResults {
                    SearchResultsGridView(items: viewModel.items, columns: columns)
                } else if !searchText.isEmpty {
                    emptyResultsView
                } else {
                    InitialStateView { selectedTags in
                        searchText = selectedTags
                    }
                }
            }
            .overlay {
                viewModel.isLoading ? loadingOverlayView : nil
            }
            .searchable(text: $searchText, prompt: "Search images (use comma for multiple tags)")
            .navigationTitle("Flickr Search")
            .onChange(of: searchText) { _, newValue in
                Task {
                    do {
                        try await viewModel.search(for: newValue)
                    } catch {
                        showError(error)
                    }
                }
            }
            .alert("Error", isPresented: $showError) {
                Button("OK") { showError = false }
                Button("Reset Search", role: .destructive) {
                    searchText = ""
                    showError = false
                }
            } message: {
                Text(errorMessage ?? "Unknown error")
            }
        }
    }
    
    private var emptyResultsView: some View {
        ContentUnavailableView("No Results",
            systemImage: "magnifyingglass",
            description: Text("Try searching for something else"))
    }
    
    private var loadingOverlayView: some View {
        ProgressView()
            .scaleEffect(1.5)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(.ultraThinMaterial)
    }
    
    
    private func showError(_ error: Error) {
        errorMessage = error.localizedDescription
        showError = true
    }
}

#Preview {
    FlickrSearchView()
}
