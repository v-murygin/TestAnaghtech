//
//  FlickrSearchView.swift
//  TestAnaghtech
//
//  Created by Vladislav Murygin on 2/12/25.
//

import SwiftUI

struct FlickrSearchView: View {
    
    @Environment(\.networkService) private var networkService
    
    
    @State private var searchText = ""
    @State private var viewModel = FlickrViewModel()
    
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
                    }
                    catch {
                        viewModel.handleError(error)
                    }
                }
            }
            .task {
                viewModel.setup(networkService: networkService)
            }
            .alert("Error", isPresented: $viewModel.showError) {
                Button("OK") { viewModel.showError = false }
                Button("Reset Search", role: .destructive) {
                    searchText = ""
                    viewModel.showError = false
                }
            } message: {
                Text(viewModel.errorMessage ?? "Unknown error")
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
}

#Preview {
    FlickrSearchView()
}
