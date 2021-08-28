//
//  GitHubRepoData.swift
//  KLproject
//
//  Created by KL on 28/08/2021.
//

import Foundation

struct GitHubRepoData: Decodable {
    
    private enum CodingKeys: String, CodingKey {
        case name
        case url = "html_url"
    }
    
    let name: String
    let url: String
}
