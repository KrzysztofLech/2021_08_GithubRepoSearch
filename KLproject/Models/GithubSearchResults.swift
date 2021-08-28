//
//  GithubSearchResults.swift
//  KLproject
//
//  Created by KL on 28/08/2021.
//

import Foundation

struct GithubSearchResults: Decodable {
    let items: [GitHubRepoData]
}
