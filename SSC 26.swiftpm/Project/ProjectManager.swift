//
//  ProjectManager.swift
//  SSC 26
//
//  Created by Thomas Conchon on 12/6/25.
//

import Foundation
import UniformTypeIdentifiers
import SwiftUI

struct ProjectManager {
    private(set) var projects: [Project]
    
    init() {
        projects = Self.loadProjects()
    }
    
    static func loadProjects() -> [Project] {
        if let data = UserDefaults.standard.data(forKey: "projects") {
            let decoder = JSONDecoder()
            if let newProjects = try? decoder.decode([Project].self, from: data) {
                return newProjects
            }
        }
        return []
    }
    
    func saveProjects(_ projects: [Project]) {
        let encoder = JSONEncoder()
        if let data = try? encoder.encode(projects) {
            UserDefaults.standard.set(data, forKey: "projects")
        }
    }

    mutating func reloadProjectsFromStorage() {
        projects = Self.loadProjects()
    }
    
    
    mutating func addProject(_ project: Project) {
        projects.append(project)
        saveProjects(projects)
    }

    mutating func delete(atIndex index: Int) {
        projects.remove(at: index)
        saveProjects(projects)
    }
    
    mutating func update(atIndex index: Int, project: Project) {
        projects[index] = project
        saveProjects(projects)
    }
    
    mutating func addSubtasks(atIndex index: Int, project: Project, subtask: Subtask) {
        projects[index].subtasks.append(subtask)
        saveProjects(projects)
    }
    
    mutating func completeSubtask(atProjectIndex projectIndex: Int, atSubtaskIndex subtaskIndex: Int) {
        projects[projectIndex].subtasks[subtaskIndex].isComplete.toggle()
        saveProjects(projects)
    }
    
    mutating func updateSubtask(atProjectIndex projectIndex: Int, atSubtaskIndex subtaskIndex: Int, subtask: Subtask) {
        projects[projectIndex].subtasks[subtaskIndex] = subtask
        saveProjects(projects)
    }
    
    mutating func deleteSubtask(atProjectIndex projectIndex: Int, atSubtaskIndex subtaskIndex: Int) {
        projects[projectIndex].subtasks.remove(at: subtaskIndex)
        saveProjects(projects)
    }
    
    
    
    
    @MainActor func exportProjects(_ projects: [Project], from vc: UIViewController) {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted

        do {
            let data = try encoder.encode(projects)
            let tempURL = FileManager.default.temporaryDirectory.appendingPathComponent("projects.json") //TODO: change name
            try data.write(to: tempURL)

            let picker = UIDocumentPickerViewController(forExporting: [tempURL])
            vc.present(picker, animated: true)
        } catch {
            print("Export error:", error)
        }
    }

    
    func importProjects(from url: URL) {
        guard url.startAccessingSecurityScopedResource() else {
            print("Could not access security scoped resource")
            return
        }
        
        defer {
            url.stopAccessingSecurityScopedResource()
        }
        
        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            let importedProjects = try decoder.decode([Project].self, from: data)
            
            UserDefaults.standard.removeObject(forKey: "projects")
            saveProjects(importedProjects)
        } catch {
        }
    }
}
//FIXME: Clean up this code
