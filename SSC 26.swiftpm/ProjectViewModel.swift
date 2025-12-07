//
//  File.swift
//  SSC 26
//
//  Created by Thomas Conchon on 12/6/25.
//

import Foundation
import SwiftUI

class ProjectViewModel: ObservableObject {
    @Published private var model = createProjectModel()
    
    private static func createProjectModel() -> ProjectModel {
        ProjectModel()
    }
    
    
    func decode() -> [ProjectModel.Project] {
//            guard let url = Bundle.main.url(forResource: "data", withExtension: ".json") else {
//                fatalError("Faliled to locate data in bundle")
//            }
        
        let url = URL(fileURLWithPath: "/Users/thomasconchon/Documents/Dev/GitHub/SSC 26.swiftpm/data.json")
        
        guard let data = try? Data(contentsOf: url) else {
            fatalError("Failed to load file from from bundle")
        }
        
        let decoder = JSONDecoder()
        
        guard let projects = try? decoder.decode([ProjectModel.Project].self, from: data) else {
            fatalError("Failed to decode from bundle")
        }
        
        return projects
    }
}

