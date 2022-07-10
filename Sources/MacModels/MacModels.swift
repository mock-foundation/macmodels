//
//  MacModels.swift
//
//
//  Created by Егор Яковенко on 08.07.2022.
//

import Foundation
import AppleScraper

public struct MacModels {
    // Deliberately private because for what you want
    // to init this struct? Like, really 🧐
    private init() { }
        
    public static func getAllDevices(locally: Bool = false) throws -> [DeviceGroup] {
        var json = ""
        if locally {
            json = try String(contentsOf: Bundle.module.url(
                forResource: "models",
                withExtension: "json"
            )!)
        } else {
            json = Scraper.run(renderer: "json", type: "all")
        }
                
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
    }
    
    public static func getDevice(by id: String) -> Device? {
        let deviceGroups = try? getAllDevices()
        guard let deviceGroups = deviceGroups else { return nil }
        for group in deviceGroups {
            for device in group.devices {
                if device.identifiers.contains(id) {
                    return device
                }
            }
        }
        return nil
    }
}
