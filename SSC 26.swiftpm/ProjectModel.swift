//
//  File.swift
//  SSC 26
//
//  Created by Thomas Conchon on 12/6/25.
//

import Foundation

struct ProjectModel {
    
    struct Project: Equatable, Codable, Identifiable, CustomDebugStringConvertible {

        let id: Int
        let title: String
        let description: String
        var progress: Int
        var deadline: String
        var debugDescription: String {
            "\(id): \(title) \(description) \(progress) "
        }
    }
    
    
}
