//
//  DataService.swift
//  KLproject
//
//  Created by KL on 28/08/2021.
//

import UIKit

protocol DataServiceProtocol {
    func fetchData(completion: @escaping (Result<GithubSearchResults, ErrorResult>) -> ())
}

final class DataService: DataServiceProtocol {
    
    private enum Constants {
        static let endpoint = "https://api.github.com/search/repositories?q=2018-07_ISS-Location"
    }
    
    private var downloadTask: URLSessionDownloadTask?
    
    func fetchData(completion: @escaping (Result<GithubSearchResults, ErrorResult>) -> ()) {
        guard let url = URL(string: Constants.endpoint) else {
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
