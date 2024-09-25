//
//  RemoteSportsRepository.swift
//  KaizenGame
//
//  Created by Gustavo Quenca on 24/09/2024.
//

import Foundation

protocol SportsRepository {
    func fetchSportsData() async throws -> [Sport]
}

class RemoteSportsRepository: SportsRepository {
    
    func fetchSportsData() async throws -> [Sport] {
        let urlString: String = "https://0083c2a8-dfe1-4a25-a7f7-8cc32f1de2c3.mock.pstmn.io/api/sports"
        
        guard let url = URL(string: urlString) else {
            throw NetworkError.invalidURL
        }
        
        let request = URLRequest(url: url)
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse, 200..<300 ~= httpResponse.statusCode else {
                throw NetworkError.invalidResponse
            }
            
            let sportsData = try JSONDecoder().decode([Sport].self, from: data)
            return sportsData
        } catch {
            if let decodingError = error as? DecodingError {
                throw NetworkError.decodingError(decodingError)
            } else {
                throw NetworkError.networkError(error)
            }
        }
    }
}
