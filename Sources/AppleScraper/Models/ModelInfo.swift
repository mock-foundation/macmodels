//
//  ModelInfo.swift
//  
//
//  Created by Егор Яковенко on 10.07.2022.
//

import Foundation

public struct ModelInfo {
    var models: String {
        return "\(model)s"
    }
    
    var model, alternativeURL, urlString, shortName: String
    
    public init(_ model: String, _ urlString: String, _ alternativeURL: String, _  shortName: String) {
        self.model = model
        self.alternativeURL = alternativeURL
        self.urlString = urlString
        self.shortName = shortName
    }
    
    var url: URL {
        return URL(string: urlString)!
    }
}
