//
//  ProjectViewModel.swift
//  SSC 26
//
//  Created by Thomas Conchon on 12/6/25.
//

import Foundation
import SwiftUI
import UniformTypeIdentifiers


class ProjectViewModel: ObservableObject {
    @Published private var model = createProjectModel()
    typealias Project = ProjectManager.Project
    
    private static func createProjectModel() -> ProjectManager {
        ProjectManager()
    }
    
    var projects: [Project] {
        model.projects
    }
    
    func saveProjects(_ projects: [Project]) {
        model.saveProjects(projects)
    }
    
    func loadProjects() {
        model.reloadProjectsFromStorage()
    }

    @MainActor func exportProjects(_ projects: [Project], from vc: UIViewController) {
        model.exportProjects(projects, from: vc)
    }
    
    func deleteAccount() {
        UserDefaults.standard.removeObject(forKey: "projects")
    }
    
    func importProjects(from url: URL) {
        model.importProjects(from: url)
    }
    
    //MARK: - User Intents
    
    func addProject(title: String, description: String, deadline: Date) {
        let newID = (projects.last?.id ?? 0) + 1
        let project: ProjectManager.Project = .init(id: newID, title: title, description: description, progress: 0, status:  ProjectManager.Status.inProgress, priority: ProjectManager.Priority.normal, subTasks: nil, deadline: deadline)
        model.addProject(project)
        loadProjects()
    }
        
    func choose(project: Project) {
        loadProjects()
    }
    
    func delete(project: Project) {
        if let index = projects.firstIndex(where: { $0.id == project.id }) {
            model.delete(at: index)
        }
    }
    
    func update(project: Project) {
        if let index = projects.firstIndex(where: { $0.id == project.id }) {
            model.update(at: index, project: project)
        }
    }
}





struct ImportJSONView: UIViewControllerRepresentable {
    var onPick: (URL) -> Void

    func makeUIViewController(context: Context) -> UIDocumentPickerViewController {
        let picker = UIDocumentPickerViewController(forOpeningContentTypes: [UTType.json])
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: UIDocumentPickerViewController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(onPick: onPick)
    }

    class Coordinator: NSObject, UIDocumentPickerDelegate {
        var onPick: (URL) -> Void

        init(onPick: @escaping (URL) -> Void) {
            self.onPick = onPick
        }

        func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
            guard let url = urls.first else { return }
            onPick(url)
        }
    }
}

//TODO: rework the viewModel and the model

