//
//  main.swift
//  
//
//  Created by Егор Яковенко on 10.07.2022.
//

import Foundation
import AppleScraper

let modelsFileURL = URL(fileURLWithPath: "Sources/MacModels/Resources/models.json")

let newContents = Scraper.run(renderer: "json", type: "all")

try newContents.write(to: modelsFileURL, atomically: true, encoding: .utf8)

