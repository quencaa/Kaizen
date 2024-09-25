//
//  NetworkError.swift
//  KaizenGame
//
//  Created by Gustavo Quenca on 24/09/2024.
//

enum NetworkError: Error {
    case invalidURL
    case networkError(Error)
    case noData
    case decodingError(Error)
    case invalidResponse

    var localizedDescription: String {
        switch self {
        case .invalidURL:
            return "The URL is invalid."
        case .networkError(let error):
            return "Network error occurred: \(error.localizedDescription)"
        case .noData:
            return "No data was returned from the server."
        case .decodingError(let error):
            return "Failed to decode JSON: \(error.localizedDescription)"
        case .invalidResponse:
            return "Invalid response from the server."
        }
    }
}
