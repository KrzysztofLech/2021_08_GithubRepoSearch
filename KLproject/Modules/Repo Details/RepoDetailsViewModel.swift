//
//  RepoDetailsViewModel.swift
//  KLproject
//
//  Created by KL on 28/08/2021.
//

import Foundation

protocol RepoDetailsViewModelProtocol {
    var title: String { get }
    var url: URL? { get }
}

final class RepoDetailsViewModel: RepoDetailsViewModelProtocol {
    
    private let repoData: GitHubRepoData
    
    var title: String {
        return repoData.name
    }
    
    var url: URL? {
        return URL(string: repoData.url)
    }
    
    init(repoData: GitHubRepoData) {
        self.repoData = repoData
    }
}
