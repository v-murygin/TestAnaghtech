//
//  NetworkServiceProtocol.swift
//  TestAnaghtech
//
//  Created by Vladislav Murygin on 2/12/25.
//

import Foundation
import UIKit


protocol NetworkServiceProtocol {
    func searchPhotos<T: Decodable>(query: String) async throws -> T
    func loadImage(from urlString: String) async throws -> UIImage
}
