//
//  Renderer.swift
//  
//
//  Created by Егор Яковенко on 10.07.2022.
//

import Foundation

public protocol Renderer {
    static func render(devices: [Device], model: ModelInfo, isLastModel: Bool) -> String
    static func header() -> String
    static func footer() -> String
}

extension Renderer {
    public static func header() -> String { "" }
    public static func footer() -> String { "" }
}
