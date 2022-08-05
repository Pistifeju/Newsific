//
//  APICaller.swift
//  Newsific
//
//  Created by István Juhász on 2022. 08. 05..
//

import Foundation

final class APICaller {
    static let shared = APICaller()
    
    public func fetchNews(completion: @escaping (Result<APIResponse, NetworkError>) -> Void) {
        let url = URL(string: "https://api.currentsapi.services/v1/latest-news?%22,%22language=en&apiKey=kYX_Tdx4NpYoMZk9sjzdaQbFsSCuHZNpS8rOzSgDxF7f7jsW")!
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                completion(.failure(NetworkError.serverError))
                return
            }
            
            do {
                let news: APIResponse = try JSONDecoder().decode(APIResponse.self, from: data)
                completion(.success(news))
            } catch {
                completion(.failure(NetworkError.decodingError))
            }
        }.resume()
    }
}
