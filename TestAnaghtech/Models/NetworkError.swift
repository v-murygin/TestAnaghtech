//
//  NetworkError.swift
//  TestAnaghtech
//
//  Created by Vladislav Murygin on 2/12/25.
//

import Foundation

// NetworkError.swift
enum NetworkError: Error {
    case invalidURL
    case invalidResponse
    case decodingError
    case serverError(Int)
    case unknown
    case invalidImageData
    
    var description: String {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .invalidResponse:
            return "Invalid response from server"
        case .decodingError:
            return "Error decoding data"
        case .serverError(let code):
            return "Server error: \(code)"
        case .invalidImageData:
            return "Invalid data received from server"
        case .unknown:
            return "Unknown error occurred"
        }
    }
}
