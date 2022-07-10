//
//  HumanRenderer.swift
//  
//
//  Created by Егор Яковенко on 10.07.2022.
//

public struct HumanRenderer: Renderer {
    public static func render(devices: [Device], model: ModelInfo, isLastModel: Bool) -> String {
        return """
        🖥️ \(model.shortName)
        🔗 \(model.alternativeURL)
        
        \(devices.map { $0.toHuman}.joined(separator: "\n\n"))
        
        """
    }
}
