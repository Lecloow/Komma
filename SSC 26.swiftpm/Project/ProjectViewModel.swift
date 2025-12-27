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
    @Published var confettiCounter = 0
    
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
        let newId = (projects.last?.id ?? 0) + 1
        let project: Project = .init(id: newId, title: title, description: description, status:  Status.inProgress, priority: Priority.normal, subtasks: [], deadline: deadline)
        model.addProject(project)
        loadProjects()
    }
        
    func choose(project: Project) {
        loadProjects()
    }
    
    func delete(project: Project) {
        if let index = projects.firstIndex(where: { $0.id == project.id }) {
            model.delete(atIndex: index)
            loadProjects()
        }
    }
    
    func update(project: Project) {
        if let index = projects.firstIndex(where: { $0.id == project.id }) {
            model.update(atIndex: index, project: project)
            loadProjects()
        }
    }
    
    func completeSubtask(subtask: Subtask) {
        if let projectIndex = projects.firstIndex(where: { $0.id == subtask.projectId }) {
                if let subtaskIndex = projects[projectIndex].subtasks.firstIndex(where: { $0.id == subtask.id }) {
                    model.completeSubtask(atProjectIndex: projectIndex, atSubtaskIndex: subtaskIndex)
                    loadProjects()
                    if !subtask.isComplete {
                        confettiCounter += 1
                    }
                }
        }
    }
    
    func addSubtask(project: Project, title: String) {
        if let index = projects.firstIndex(where: { $0.id == project.id }) {
            let newId = (projects[index].subtasks.last?.id ?? 0) + 1
            let subtask = Subtask(id: newId, projectId: project.id, title: title, isComplete: false)
            model.addSubtasks(atIndex: index, project: project, subtask: subtask)
            loadProjects()
        }
    }
    
    func updateSubtask(subtask: Subtask) {
        if let projectIndex = projects.firstIndex(where: { $0.id == subtask.projectId }) {
            if let subtaskIndex = projects[projectIndex].subtasks.firstIndex(where: { $0.id == subtask.id }) {
                model.updateSubtask(atProjectIndex: projectIndex, atSubtaskIndex: subtaskIndex, subtask: subtask)
                loadProjects()
            }
        }
    }
    
    func moveSubTask(in project: Project, from source: IndexSet, to destination: Int) {
        if let projectIndex = projects.firstIndex(where: { $0.id == project.id }) {
            model.moveSubtask(atProjectIndex: projectIndex, from: source, to: destination)
            loadProjects()
        }
    }
    
    func deleteSubtask(subtask: Subtask) {
        if let projectIndex = projects.firstIndex(where: { $0.id == subtask.projectId }) {
            if let subtaskIndex = projects[projectIndex].subtasks.firstIndex(where: { $0.id == subtask.id }) {
                model.deleteSubtask(atProjectIndex: projectIndex, atSubtaskIndex: subtaskIndex)
                loadProjects()
            }
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

