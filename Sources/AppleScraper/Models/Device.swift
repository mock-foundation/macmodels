//
//  Device.swift
//  
//
//  Created by Егор Яковенко on 10.07.2022.
//

public struct Device {
    var name, kb, shortName: String
    var identifier: [String]
    var image, modelName: String
    
    var toDeviceKit: String {
        return """
        Device(
        "\(name)",
        "Device is a [\(modelName)](\(kb))",
        "https://support.apple.com\(image)",
        ["\(identifier.joined(separator: "\" ,\""))"], 0, (), "\(modelName)", -1, False, False, False, False, False, False, False, False, False, 0, False, 0)
        """
    }
    
    var toMarkdown: String {
        return """
        ### [\(modelName)](\(kb))
        * identifier: \(identifier.joined(separator: ","))
        ![\(name)](https://support.apple.com\(image))
        """
    }
    
    var toHuman: String {
        return """
          🖥️ \(modelName)
          🔗 \(kb)
          🖼️ https://support.apple.com\(image)
          🆔 \(identifier.joined(separator: ", "))
        """
    }
    
    var toJSON: String {
        return """
        {
         "modelName": "\(modelName)",
         "name": "\(name)",
         "shortName": "\(shortName)",
         "kb": "\(kb)",
         "image": "https://support.apple.com\(image)",
         "identifiers": "\(identifier.joined(separator: ", "))"
        }
        """
    }
}
