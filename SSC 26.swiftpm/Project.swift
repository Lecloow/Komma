//
//  Project.swift
//  SSC 26
//
//  Created by Thomas Conchon on 12/20/25.
//

import Foundation

struct Project: Equatable, Codable, Identifiable, CustomDebugStringConvertible {
    let id: Int
    var title: String
    var description: String
    var progress: Int {
        guard !subTasks.isEmpty else { return 0 }
        
        let completedCount = subTasks.filter{ $0.isComplete }.count
        let totalCount = subTasks.count
        
        return Int((Double(completedCount) / Double(totalCount)) * 100)
    }
    var status: Status
    var priority: Priority
    var subTasks: [SubTask]
    var deadline: Date
    var debugDescription: String {
        "\(id): title: \(title) \(description) \(progress), subTasks: \(subTasks)"
    }
}

enum Status: Codable {
    case later, onHold, inProgress, inReview, done
}

enum Priority: Codable {
    case low, normal, high, urgent //FIXME: CHange priority
}

struct SubTask: Codable, Identifiable, Equatable {
    let id: Int
    var title: String
    var isComplete: Bool
}

//FIXME: Change name of the file
