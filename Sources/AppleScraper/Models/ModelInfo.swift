//
//  ModelInfo.swift
//  
//
//  Created by Егор Яковенко on 10.07.2022.
//

import Foundation

public struct ModelInfo {
    var name: String
    var supportURL, specsURL: URL
    
    init(name: String, supportURL: String, specsURL: String) {
        self.name = name
        self.supportURL = URL(string: supportURL)!
        self.specsURL =  URL(string: specsURL)!
    }
}
