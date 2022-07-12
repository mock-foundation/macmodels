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
    
    /// Gets the device list from a local` models.json` file. You can also
    /// get this list from the web by using ``getAllDevicesOnline()``.
    /// - Returns: Serialized from `models.json` array of `DeviceGroup`.
    public static func getAllDevicesLocally() throws -> [DeviceGroup] {
        let json = try String(contentsOf: Bundle.module.url(
            forResource: "models",
            withExtension: "json"
        )!)
        
        let groups = try JSONDecoder().decode([DeviceGroup].self, from: json.data(using: .utf8)!)
        
        return groups
    }
        
    /// Gets the device list from Apple Support website by scraping it.
    /// You can also do it locally by using ``getAllDevicesLocally()``
    /// instead.
    /// - Returns: The scraped and deserialized array of `DeviceGroup`.
    public static func getAllDevicesOnline() async throws -> [DeviceGroup] {
        return try await Scraper.scrape(for: "all")
    }
    
    /// Get a device from a local list by it's ID.
    /// - Parameter id: The ID of the device to search for, like `MacBookPro13,1`.
    /// - Returns: A `Device` if found, `nil` if not.
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
    
    /// Searches for a device by scraping the Apple Support website using the device's ID.
    /// - Parameter id: The ID of the device to search for, like `MacBookPro13,1`.
    /// - Returns: A `Device` if found, `nil` if not.
    public static func getDeviceOnline(by id: String) async -> Device? {
        let deviceGroups = try? await getAllDevicesOnline()
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
    
    /// Searches for a device by it's ID.
    ///
    /// It first tries to find the device locally, using a local list. If found, it returns
    /// the device, if not, tries to find it online by scraping the Apple Support website.
    /// If found, returns it, if not, returns `nil`.
    /// - Parameter id: The ID of the device to search for, like `MacBookPro13,1`.
    /// - Returns: A `Device` if found, `nil` if not.
    public static func getDevice(by id: String) async -> Device? {
        if let local = MacModels.getDeviceLocally(by: id) {
            return local
        } else {
            return await MacModels.getDeviceOnline(by: id)
        }
    }
}
