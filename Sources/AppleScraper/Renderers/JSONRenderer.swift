//
//  JSONRenderer.swift
//  
//
//  Created by Егор Яковенко on 10.07.2022.
//

public struct JSONRenderer: Renderer {
    public static func render(devices: [Device], model: ModelInfo, isLastModel: Bool) -> String {
        """
        {
         "name": "\(model.shortName)",
         "URL": "\(model.urlString)",
         "alternativeURL": "\(model.alternativeURL)",
         "devices": [
           \((devices.map { $0.toJSON}.joined(separator: ",")))
         ]
        }
        \(!isLastModel ? "," : "")
        """
    }
    
    public static func header() -> String { "{ \"models\": [" }
    public static func footer() -> String { "]}" }
}
