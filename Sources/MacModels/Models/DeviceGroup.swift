//
//  DeviceGroup.swift
//  
//
//  Created by Егор Яковенко on 08.07.2022.
//

import Foundation

public struct DeviceGroup: Codable, Equatable {
    let name: String
    let url: URL
    let alternativeURL: URL
    let devices: [Device]
    
    enum CodingKeys: String, CodingKey {
        case name, alternativeURL, devices
        case url = "URL"
    }
}
