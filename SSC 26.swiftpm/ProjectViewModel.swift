//
//  File.swift
//  SSC 26
//
//  Created by Thomas Conchon on 12/6/25.
//

import Foundation
import SwiftUI
import UniformTypeIdentifiers


class ProjectViewModel: ObservableObject {
    @Published private var model = createProjectModel()
    typealias Project = ProjectModel.Project
    
    private static func createProjectModel() -> ProjectModel {
        ProjectModel()
    }
    
    
//    func decode() -> [ProjectModel.Project] {
////            guard let url = Bundle.main.url(forResource: "data", withExtension: "json") else { //FIXME: Doesn't work for some obscur reason
////                fatalError("Faliled to locate data in bundle")
////            }
//        
//        let url = URL(fileURLWithPath: "/Users/thomasconchon/Documents/Dev/GitHub/SSC/SSC 26.swiftpm/data.json")
//        
//        guard let data = try? Data(contentsOf: url) else {
//            fatalError("Failed to load file from from bundle")
//        }
//        
//        let decoder = JSONDecoder()
//        
//        guard let projects = try? decoder.decode([ProjectModel.Project].self, from: data) else {
//            fatalError("Failed to decode from bundle")
//        }
//        
//        return projects
//    }
//    
//    
//    func encode(_ projects: [ProjectModel.Project]) {
//        let url = URL(fileURLWithPath: "/Users/thomasconchon/Documents/Dev/GitHub/SSC/SSC 26.swiftpm/data.json")
//        
//        do {
//            let encoder = JSONEncoder()
//            encoder.outputFormatting = [.prettyPrinted]
//            let data = try encoder.encode(projects)
//            try data.write(to: url)
//        } catch {
//            fatalError("Encoding failed: \(error)")
//        }
//    }
//    
//    
//    func addProject(_ newProject: ProjectModel.Project) {
//        var projects = decode()
//        projects.append(newProject)
//        encode(projects)
//    }
//    
//    func updateProgress(project: ProjectModel.Project, newProgress: Int) {
//        var projects = decode()
//        
//        if let index = projects.firstIndex(where: { $0.id == project.id }) {
//            projects[index].progress = newProgress
//            encode(projects)
//        } else {
//            print("Project not found.")
//        }
//    }
    func saveProjects(_ projects: [Project]) {
        let encoder = JSONEncoder()
        if let data = try? encoder.encode(projects) {
            UserDefaults.standard.set(data, forKey: "projects")
        }
    }
    func loadProjects() -> [Project] {
        if let data = UserDefaults.standard.data(forKey: "projects") {
            let decoder = JSONDecoder()
            if let projects = try? decoder.decode([Project].self, from: data) {
                return projects
            }
        }
        return []
    }
    func addProject(_ project: Project) {
        var projects = loadProjects()
        projects.append(project)
        saveProjects(projects)
    }
    func updateProgress(project: Project, progress: Int) {
        var projects = loadProjects()
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
            let tempURL = FileManager.default.temporaryDirectory.appendingPathComponent("projects.json")
            try data.write(to: tempURL)

            let picker = UIDocumentPickerViewController(forExporting: [tempURL])
            vc.present(picker, animated: true)
        } catch {
            print("Export error:", error)
        }
    }
    
    func resetProjects() {
        UserDefaults.standard.removeObject(forKey: "projects")
    }
    
    func importProjects(from url: URL) {
        // 1. Démarrer l'accès sécurisé
        guard url.startAccessingSecurityScopedResource() else {
            print("Could not access security scoped resource")
            return
        }
        
        defer {
            // 3. Toujours libérer à la fin
            url.stopAccessingSecurityScopedResource()
        }
        
        do {
            // 2. Charger le JSON
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            let importedProjects = try decoder.decode([Project].self, from: data)
            
            // Écraser et sauvegarder
            UserDefaults.standard.removeObject(forKey: "projects")
            saveProjects(importedProjects)
        } catch {
        }
    }
}

