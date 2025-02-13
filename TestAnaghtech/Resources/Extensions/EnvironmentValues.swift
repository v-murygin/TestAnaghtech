//
//  EnvironmentValues.swift
//  TestAnaghtech
//
//  Created by Vladislav Murygin on 2/13/25.
//

import SwiftUI


extension EnvironmentValues {
    @Entry var networkService: NetworkServiceProtocol = NetworkService(cache: .shared)
}
