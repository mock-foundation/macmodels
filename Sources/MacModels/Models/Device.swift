//
//  Device.swift
//  
//
//  Created by Егор Яковенко on 08.07.2022.
//

public struct Device: Codable, Equatable {
    let modelName: String
    let name: String
    let shortName: String
    let kb: String
    let image: String
    let identifiers: [String]
}
