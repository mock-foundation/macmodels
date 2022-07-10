//
//  ModelInfo.swift
//  
//
//  Created by Егор Яковенко on 10.07.2022.
//

import Foundation

public struct DeviceGroup {
    var name: String
    var supportURL, specsURL: URL
    var devices: 
    
    init(name: String, supportURL: String, specsURL: String) {
        self.name = name
        self.supportURL = URL(string: supportURL)!
        self.specsURL =  URL(string: specsURL)!
    }
}
