//
//  ListViewModel.swift
//  KLproject
//
//  Created by KL on 28/08/2021.
//

import Foundation

protocol ListViewModelProtocol {
    var repositoriesData: [GitHubRepoData] { get }
    var title: String { get }
    func fetchData(withPhrase phrase: String, completion: @escaping (String?) -> ())
}

final class ListViewModel: ListViewModelProtocol {
    
    private let dataService: DataServiceProtocol
    
    var repositoriesData: [GitHubRepoData] = []
    var title: String {
        return "Github repositories (\(repositoriesData.count))"
    }
    
    init(dataService: DataServiceProtocol) {
        self.dataService = dataService
    }
    
    func fetchData(withPhrase phrase: String, completion: @escaping (String?) -> ()) {
        let query = phrase.convertToQueryFormat()
        dataService.fetchData(withQuery: query) { [weak self] response in
            switch response {
            case .success(let data):
                self?.repositoriesData = data.items
                completion(nil)
            case .failure(let error):
                completion(error.rawValue)
            }
        }
    }
}
