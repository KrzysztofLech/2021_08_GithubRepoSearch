//
//  String+extensions.swift
//  KLproject
//
//  Created by KL on 28/08/2021.
//

import Foundation

extension String {
    func convertToQueryFormat() -> String {
        return self.replacingOccurrences(of: " ", with: "+")
    }
}
