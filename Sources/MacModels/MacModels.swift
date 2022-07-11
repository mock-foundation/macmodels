//
//  MacModels.swift
//
//
//  Created by Егор Яковенко on 08.07.2022.
//

import Foundation
import SharedModels
import AppleScraper

public struct MacModels {
    // Deliberately private because for what you want
    // to init this struct? Like, really 🧐
    private init() { }
    
    public static func getAllDevicesLocally() throws -> [DeviceGroup] {
        let json = try String(contentsOf: Bundle.module.url(
            forResource: "models",
            withExtension: "json"
        )!)
        
        let groups = try JSONDecoder().decode([DeviceGroup].self, from: json.data(using: .utf8)!)
        
        return groups
    }
        
    /// Fetches device list from the Apple Support website.
    public static func getAllDevices() async throws -> [DeviceGroup] {
        return try await Scraper.scrape(for: "all")
    }
    
    public static func getDeviceLocally(by id: String) -> Device? {
        let deviceGroups = try? getAllDevicesLocally()
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
    
    public static func getDevice(by id: String) async -> Device? {
        let deviceGroups = try? await getAllDevices()
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
