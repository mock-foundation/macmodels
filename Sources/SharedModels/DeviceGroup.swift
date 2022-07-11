//
//  DeviceGroup.swift
//  
//
//  Created by Егор Яковенко on 08.07.2022.
//

import Foundation

public struct DeviceGroup: Codable, Equatable {
    public let name: String
    public let supportURL, specsURL: URL
    public let devices: [Device]
    
    public init(name: String, supportURL: URL, specsURL: URL, devices: [Device] = []) {
        self.name = name
        self.supportURL = supportURL
        self.specsURL = specsURL
        self.devices = devices
    }
}
