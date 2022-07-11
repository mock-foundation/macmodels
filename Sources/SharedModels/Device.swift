//
//  Device.swift
//  
//
//  Created by Егор Яковенко on 08.07.2022.
//

import Foundation

public struct Device: Codable, Equatable {
    public let name, shortName: String
    public let specsURL, imageURL: URL
    public let identifiers: [String]
    
    public init(
        name: String,
        shortName: String,
        specsURL: URL,
        imageURL: URL,
        identifiers: [String]
    ) {
        self.name = name
        self.shortName = shortName
        self.specsURL = specsURL
        self.imageURL = imageURL
        self.identifiers = identifiers
    }
}
