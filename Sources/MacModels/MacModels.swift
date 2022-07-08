//
//  MacModels.swift
//
//
//  Created by Егор Яковенко on 08.07.2022.
//

import Foundation

public struct MacModels {
    // Deliberately private because for what you want
    // to init this struct? Like, really 🧐
    private init() { }
    
    public static func getAllModels() -> [DeviceGroup] {
        do {
            let json = try String(contentsOf: Bundle.module.url(
                forResource: "models",
                withExtension: "json"
            )!)
            
            let data = try JSONDecoder().decode(JSONRoot.self, from: json.data(using: .utf8)!)
            
            return data.models.map { group in
                DeviceGroup(
                    name: group.name,
                    url: group.url,
                    alternativeURL: group.alternativeURL,
                    devices: group.devices.map { device in
                        Device(
                            modelName: device.modelName,
                            name: device.name,
                            shortName: device.shortName,
                            kb: device.kb,
                            image: device.image,
                            identifiers: device.identifiers.components(separatedBy: ",\u{00a0}")
                        )
                    })
            }
        } catch {
            print(error)
            return []
        }
    }
}
