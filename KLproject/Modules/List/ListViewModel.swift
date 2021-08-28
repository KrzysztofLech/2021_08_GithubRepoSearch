//
//  ListViewModel.swift
//  KLproject
//
//  Created by KL on 28/08/2021.
//

import Foundation

protocol ListViewModelProtocol {
    var repositoriesData: [GitHubRepoData] { get }
    func fetchData(completion: @escaping (String?) -> ())
}

final class ListViewModel: ListViewModelProtocol {
    
    private let dataService: DataServiceProtocol
    var repositoriesData: [GitHubRepoData] = []
    
    init(dataService: DataServiceProtocol) {
        self.dataService = dataService
    }
    
    func fetchData(completion: @escaping (String?) -> ()) {
        dataService.fetchData { [weak self] response in
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
