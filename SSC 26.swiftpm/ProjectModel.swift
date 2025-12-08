//
//  ProjectModel.swift
//  SSC 26
//
//  Created by Thomas Conchon on 12/6/25.
//

import Foundation
import UniformTypeIdentifiers
import SwiftUI


struct ProjectModel {
    private(set) var projects: [Project]
    
    init() {
        projects = Self.loadProjects()
    }
    
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
    
    func saveProjects(_ projects: [Project]) {
        let encoder = JSONEncoder()
        if let data = try? encoder.encode(projects) {
            UserDefaults.standard.set(data, forKey: "projects")
        }
    }
    mutating func reloadProjectsFromStorage() {
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
    
    mutating func addProject(_ project: Project) {
        projects.append(project)
        saveProjects(projects)
    }
    
    mutating func updateProgress(project: Project, progress: Int) {
        if let i = projects.firstIndex(where: { $0.id == project.id }) {
            projects[i].progress += progress
            saveProjects(projects)
        }
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

