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
    static let models = [
        ModelInfo(
            name: "Mac mini",
            supportURL: "https://support.apple.com/en-us/HT201894",
            specsURL: "https://support.apple.com/specs/macmini"),
        ModelInfo(
            name: "iMac",
            supportURL: "https://support.apple.com/en-us/HT201634",
            specsURL: "https://support.apple.com/mac/imac"),
        ModelInfo(
            name: "Mac Pro",
            supportURL: "https://support.apple.com/en-us/HT202888",
            specsURL: "https://support.apple.com/mac/mac-pro"),
        ModelInfo(
            name: "MacBook",
            supportURL: "https://support.apple.com/en-us/HT201608",
            specsURL: "https://support.apple.com/mac/macbook"),
        ModelInfo(
            name: "MacBook Air",
            supportURL: "https://support.apple.com/en-us/HT201862",
            specsURL: "https://support.apple.com/mac/macbook-air"),
        ModelInfo(
            name: "MacBook Pro",
            supportURL: "https://support.apple.com/en-us/HT201300",
            specsURL: "https://support.apple.com/mac/macbook-pro"),
        ModelInfo(
            name: "Mac Studio",
            supportURL: "https://support.apple.com/en-us/HT213073",
            specsURL: "https://support.apple.com/mac/mac-studio")
    ]
    
    public static func models(for string: String) -> [ModelInfo] {
        let allModels = Scraper.models
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
    
    public static func scrape(for type: String) async -> String {
        let models = Scraper.models(for: type)
        
        var result = ""
        
        result = result + renderer.header()
        for (index, model) in models.enumerated() {
            let (data, response, error) = URLSession.shared.synchronousDataTask(with: model.supportURL)
            guard let dataUnwrapped = data, let html = String(data: dataUnwrapped, encoding: .utf8)  else {
                print("\(String(describing: error)), \(String(describing: response))")
                // XXX will make json not valid, maybe send error to renderer
                continue
            }
            var devices: [Device] = []
            do {
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
                                name: modelName.camelCased,
                                kb: linkHref,
                                shortName: model.shortName,
                                identifier: identifiers,
                                image: image,
                                modelName: modelName)
                            if !device.identifier.isEmpty, !devices.contains(where: { return $0.name == device.name}) {
                                devices.append(device)
                            }
                        }
                    }
                }
            } catch Exception.Error(_, let message) {
                print(message)
            } catch {
                print("error")
            }
            
            result = result + renderer.render(devices: devices, model: model, isLastModel: (index + 1) == models.count)
        }
        result = result + renderer.footer()
        
        return result
    }
}
