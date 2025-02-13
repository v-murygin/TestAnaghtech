//
//  TestAnaghtechApp.swift
//  TestAnaghtech
//
//  Created by Vladislav Murygin on 2/12/25.
//

import SwiftUI

@main
struct TestAnaghtechApp: App {
    
    @State private var networkService: NetworkServiceProtocol = NetworkService(cache: .shared)
    
    var body: some Scene {
        WindowGroup {
            FlickrSearchView()
                .environment(\.networkService, networkService)
        }
    }
}
