//
//  Scraper.swift
//
//  The scraper logic is used from
//  https://github.com/phimage/MacModelScraper/blob/master/Sources/ModelAppleScraper/Dump.swift
//
//  Created by Егор Яковенко on 10.07.2022.
//

import Foundation
import SwiftSoup

public struct Scraper {
    static let deviceGroups = [
        DeviceGroup(
            name: "Mac mini",
            supportURL: "https://support.apple.com/en-us/HT201894",
            specsURL: "https://support.apple.com/specs/macmini"),
        DeviceGroup(
            name: "iMac",
            supportURL: "https://support.apple.com/en-us/HT201634",
            specsURL: "https://support.apple.com/mac/imac"),
        DeviceGroup(
            name: "Mac Pro",
            supportURL: "https://support.apple.com/en-us/HT202888",
            specsURL: "https://support.apple.com/mac/mac-pro"),
        DeviceGroup(
            name: "MacBook",
            supportURL: "https://support.apple.com/en-us/HT201608",
            specsURL: "https://support.apple.com/mac/macbook"),
        DeviceGroup(
            name: "MacBook Air",
            supportURL: "https://support.apple.com/en-us/HT201862",
            specsURL: "https://support.apple.com/mac/macbook-air"),
        DeviceGroup(
            name: "MacBook Pro",
            supportURL: "https://support.apple.com/en-us/HT201300",
            specsURL: "https://support.apple.com/mac/macbook-pro"),
        DeviceGroup(
            name: "Mac Studio",
            supportURL: "https://support.apple.com/en-us/HT213073",
            specsURL: "https://support.apple.com/mac/mac-studio")
    ]
    
    public static func deviceGroup(for string: String) -> [DeviceGroup] {
        let allModels = Scraper.deviceGroups
        if string.isEmpty || string == "all" {
            return allModels
        }
        let modelStrings = string.split(separator: ",")
        
        return modelStrings.compactMap {
            for model in allModels {
                if model.name.lowercased() == $0.lowercased() {
                    return model
                }
            }
            return nil
        }
    }
    
    public static func scrape(for type: String) async throws -> String {
        let models = Scraper.deviceGroup(for: type)
        
        var result: [DeviceGroup] = []
        
        for (index, model) in models.enumerated() {
            let (data, response) = try await URLSession.shared.data(from: model.supportURL)
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
                            kb: linkHref,
                            shortName: model.name,
                            identifier: identifiers,
                            image: image)
                        
                        if !device.identifier.isEmpty, !devices.contains(where: { return $0.name == device.name}) {
                            devices.append(device)
                        }
                    }
                }
            }
            
            result.append(DeviceGroup(name: model.name, supportURL: <#T##String#>, specsURL: <#T##String#>))
        }
        result = result + renderer.footer()
        
        return result
    }
}
