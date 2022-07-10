//
//  MarkdownRenderer.swift
//  
//
//  Created by Егор Яковенко on 10.07.2022.
//

public struct MarkdownRenderer: Renderer {
    public static func render(devices: [Device], model: ModelInfo, isLastModel: Bool) -> String {
        return """
        ## [\(model.shortName)](\(model.alternativeURL)) [🔎](\(model.urlString))
        
        \(devices.map { $0.toMarkdown }.joined(separator: "\n"))
        """
    }
}
