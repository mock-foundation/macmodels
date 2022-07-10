//
//  DeviceKitRenderer.swift
//  
//
//  Created by Егор Яковенко on 10.07.2022.
//

public struct DeviceKitRenderer: Renderer {
    public static func render(devices: [Device], model: ModelInfo, isLastModel: Bool) -> String {
        """
        ## \(model.alternativeURL), \(model.urlString)
        \(model.models) = [
        \(devices.map { $0.toDeviceKit }.joined(separator: ",\n"))
        ]
        """
    }
}
