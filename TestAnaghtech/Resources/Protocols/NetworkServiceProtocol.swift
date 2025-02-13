//
//  NetworkServiceProtocol.swift
//  TestAnaghtech
//
//  Created by Vladislav Murygin on 2/12/25.
//

import Foundation

protocol NetworkServiceProtocol {
    func searchPhotos<T: Decodable>(query: String) async throws -> T
}
