//
//  DataService.swift
//  KLproject
//
//  Created by KL on 28/08/2021.
//

import UIKit

protocol DataServiceProtocol {
    func fetchData(withQuery query: String, completion: @escaping (Result<GithubSearchResults, ErrorResult>) -> ())
}

final class DataService: DataServiceProtocol {
    
    private enum Constants {
        static let endpoint = "https://api.github.com/search/repositories"
    }
    
    private var downloadTask: URLSessionDownloadTask?
    
    func fetchData(withQuery query: String, completion: @escaping (Result<GithubSearchResults, ErrorResult>) -> ()) {
        let urlString = Constants.endpoint + "?q=" + query
        
        guard let url = URL(string: urlString) else {
            completion(.failure(.url))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                if let err = error as? URLError, err.code == .notConnectedToInternet {
                    completion(.failure(.noInternet))
                } else {
                    completion(.failure(.network))
                }
                return
            }

            else if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode != 200 {
                completion(.failure(.statusCode))
                return
            }

            guard let data = data else {
                completion(.failure(.other))
                return
            }
            
            do {
                let responseData = try JSONDecoder().decode(GithubSearchResults.self, from: data)
                completion(.success(responseData))
            } catch {
                completion(.failure(.parse))
            }
        }.resume()
    }
}
