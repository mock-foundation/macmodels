//
//  main.swift
//  
//
//  Created by Егор Яковенко on 10.07.2022.
//

import Foundation
import AppleScraper

let modelsFileURL = URL(fileURLWithPath: "Sources/MacModels/Resources/models.json")
let encoder = JSONEncoder()
encoder.outputFormatting = .prettyPrinted

let scraped = try await Scraper.scrape(for: "all")
let newContents = try encoder.encode(scraped)

try newContents.write(to: modelsFileURL, options: .atomic)

