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
        ModelInfo("macMini", "https://support.apple.com/en-us/HT201894", "https://support.apple.com/specs/macmini", "Mac mini"),
        ModelInfo("iMac", "https://support.apple.com/en-us/HT201634", "https://support.apple.com/mac/imac", "iMac"),
        ModelInfo("macPro", "https://support.apple.com/en-us/HT202888", "https://support.apple.com/mac/mac-pro", "Mac Pro"),
        ModelInfo("macBook", "https://support.apple.com/en-us/HT201608", "https://support.apple.com/mac/macbook", "MacBook"),
        ModelInfo("macBookAir", "https://support.apple.com/en-us/HT201862", "https://support.apple.com/mac/macbook-air", "MacBook Air"),
        ModelInfo("macBookPro", "https://support.apple.com/en-us/HT201300", "https://support.apple.com/mac/macbook-pro", "MacBook Pro"),
        ModelInfo("macStudio", "https://support.apple.com/en-us/HT213073", "https://support.apple.com/mac/mac-studio", "Mac Studio")
    ]
    
    public static func renderer(for string: String) -> Renderer.Type {
        switch string {
            case "devicekit":
                return DeviceKitRenderer.self
            case "markdown":
                return MarkdownRenderer.self
            case "human", "emoji":
                return HumanRenderer.self
            case "json":
                return JSONRenderer.self
            default:
                return HumanRenderer.self
        }
    }
    
    public static func models(for string: String) -> [ModelInfo] {
        let allModels = Scraper.models
        if string.isEmpty || string == "all" {
            return allModels
        }
        let modelStrings = string.split(separator: ",")
        
        return modelStrings.compactMap {
            for aModel in allModels {
                if aModel.model.lowercased() == $0.lowercased() {
                    return aModel
                }
            }
            return nil
        }
    }
    
    public static func run(renderer rendererString: String, type: String) -> String {
        let renderer = Scraper.renderer(for: rendererString)
        let models = Scraper.models(for: type)
        
        var result = ""
        
        result = result + renderer.header()
        for (index, model) in models.enumerated() {
            let (data, response, error) = URLSession.shared.synchronousDataTask(with: model.url)
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
