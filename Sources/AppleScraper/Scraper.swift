//
//  Scraper.swift
//
//  The scraper logic is used from
//  https://github.com/phimage/MacModelScraper/blob/master/Sources/ModelAppleScraper/Dump.swift
//
//  Created by Егор Яковенко on 10.07.2022.
//

import Foundation
import SharedModels
import SwiftSoup

public struct Scraper {
    static let deviceGroups = [
        DeviceGroup(
            name: "Mac mini",
            supportURL: URL(string: "https://support.apple.com/en-us/HT201894")!,
            specsURL: URL(string: "https://support.apple.com/specs/macmini")!),
        DeviceGroup(
            name: "iMac",
            supportURL: URL(string: "https://support.apple.com/en-us/HT201634")!,
            specsURL: URL(string: "https://support.apple.com/mac/imac")!),
        DeviceGroup(
            name: "Mac Pro",
            supportURL: URL(string: "https://support.apple.com/en-us/HT202888")!,
            specsURL: URL(string: "https://support.apple.com/mac/mac-pro")!),
        DeviceGroup(
            name: "MacBook",
            supportURL: URL(string: "https://support.apple.com/en-us/HT201608")!,
            specsURL: URL(string: "https://support.apple.com/mac/macbook")!),
        DeviceGroup(
            name: "MacBook Air",
            supportURL: URL(string: "https://support.apple.com/en-us/HT201862")!,
            specsURL: URL(string: "https://support.apple.com/mac/macbook-air")!),
        DeviceGroup(
            name: "MacBook Pro",
            supportURL: URL(string: "https://support.apple.com/en-us/HT201300")!,
            specsURL: URL(string: "https://support.apple.com/mac/macbook-pro")!),
        DeviceGroup(
            name: "Mac Studio",
            supportURL: URL(string: "https://support.apple.com/en-us/HT213073")!,
            specsURL: URL(string: "https://support.apple.com/mac/mac-studio")!)
    ]
    
    public static func deviceGroup(for models: String) -> [DeviceGroup] {
        let allModels = Scraper.deviceGroups
        if models.isEmpty || models == "all" {
            return allModels
        }
        let modelStrings = models.split(separator: ",")
        
        return modelStrings.compactMap {
            for model in allModels {
                if model.name.lowercased() == $0.lowercased() {
                    return model
                }
            }
            return nil
        }
    }
    
    public static func scrape(for model: String) async throws -> [DeviceGroup] {
        let models = Scraper.deviceGroup(for: model)
        
        var result: [DeviceGroup] = []
        
        for (_, model) in models.enumerated() {
            let (data, _) = try await URLSession.shared.data(from: model.supportURL)
            guard let html = String(data: data, encoding: .utf8) else {
                continue
            }
            
            var devices: [Device] = []
            
            let doc: Document = try SwiftSoup.parse(html)
            let links = try doc.select("a")
            for link in links {
                let linkHref: String = try link.attr("href")
                if linkHref.contains("https://support.apple.com/kb/SP") {
                    let modelName: String = try link.text()
                    guard !modelName.isEmpty else {
                        continue
                    }
                    
                    if let paragraphe = link.parent(), let paragrapheOfParent = paragraphe.parent() {
                        var identifier = try paragraphe.text()
                        if let index = identifier.endIndex(of: "Model Identifier:") {
                            identifier = String(identifier[index...])
                        } else {
                            identifier = try paragrapheOfParent.text()
                            guard let upindex = identifier.endIndex(of: "Model Identifier:") else {
                                continue
                            }
                            identifier = String(identifier[upindex...])
                        }
                        identifier = String(identifier.dropFirst())
                        identifier = String(identifier[identifier.startIndex..<identifier.index(of: " ")!])
                        identifier = String(identifier.replacingOccurrences(of: " ", with: ""))
                        let identifiers = identifier.split(separator: ";").map { String($0) }
                        
                        var image: String = ""
                        if let siblingImage = try paragraphe.previousElementSibling()?.select("img").first()?.attr("src") {
                            image = siblingImage
                        } else if let parentImage = try paragrapheOfParent.select("img").first()?.attr("src") {
                            image = parentImage
                        }
                        
                        let device = Device(
                            name: modelName,
                            shortName: model.name,
                            specsURL: URL(string: linkHref)!,
                            imageURL: URL(string: image)!,
                            identifiers: identifiers)
                        
                        if !device.identifiers.isEmpty, !devices.contains(where: { return $0.name == device.name}) {
                            devices.append(device)
                        }
                    }
                }
            }
            
            result.append(DeviceGroup(
                name: model.name,
                supportURL: model.supportURL,
                specsURL: model.specsURL,
                devices: devices))
        }
        
        return result
    }
}
