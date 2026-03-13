//
//  Project.swift
//  Kómma
//
//  Created by Thomas Conchon on 12/20/25.
//

import Foundation

struct Project: Equatable, Codable, Identifiable, CustomDebugStringConvertible {
    let id: Int
    var title: String
    var description: String
    var progress: Int {
        guard !tasks.isEmpty else { return 0 }
        
        let allSubtasks = tasks.flatMap { $0.subtasks }
        guard !allSubtasks.isEmpty else { return 0 }
        
        let completedCount = allSubtasks.filter { $0.isComplete }.count
        let totalCount = allSubtasks.count
        
        return Int(((Double(completedCount) / Double(totalCount))*100).rounded())
    }
    var status: Status
    var priority: Priority
    var tasks: [ProjectTask]
    var deadline: Date
    var debugDescription: String {
        "\(id): title: \(title) \(description) \(progress), tasks: \(tasks)"
    }
}

struct ProjectTask: Codable, Identifiable, Equatable {
    let id: Int
    let projectId: Project.ID
    var title: String
    var description: String
    var deadline: Date
    var progress: Int {
        guard !subtasks.isEmpty else { return 0 }
        let completedCount = subtasks.filter{ $0.isComplete }.count
        let totalCount = subtasks.count
        return Int(((Double(completedCount) / Double(totalCount)) * 100).rounded())
    }
    var subtasks: [Subtask]
}

struct Subtask: Codable, Identifiable, Equatable {
    let id: Int
    let projectId: Project.ID
    let taskId: ProjectTask.ID
    var title: String
    var notes: String
    var isComplete: Bool
}

enum Status: Codable {
    case later, onHold, inProgress, inReview, done
}

enum Priority: Codable {
    case low, normal, high, urgent //FIXME: Change priority
}
