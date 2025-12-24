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
        let project: Project = .init(id: newId, title: title, description: description, status:  Status.inProgress, priority: Priority.normal, subTasks: [], deadline: deadline)
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
    
    func completeSubTask(subtask: SubTask) {
        if let projectIndex = projects.firstIndex(where: { $0.id == subtask.projectId }) {
                if let subTaskIndex = projects[projectIndex].subTasks.firstIndex(where: { $0.id == subtask.id }) {
                    model.completeSubTask(atProjectIndex: projectIndex, atSubTaskIndex: subTaskIndex)
                    loadProjects()
                    if !subtask.isComplete {
                        confettiCounter += 1
                    }
                }
        }
    }
    
    func addSubTask(project: Project, title: String) {
        if let index = projects.firstIndex(where: { $0.id == project.id }) {
            let newId = (projects[index].subTasks.last?.id ?? 0) + 1
            let subTask = SubTask(id: newId, projectId: project.id, title: title, isComplete: false)
            model.addSubTasks(atIndex: index, project: project, subTask: subTask)
            loadProjects()
        }
    }
    
    func updateSubTask(subtask: SubTask) {
        if let projectIndex = projects.firstIndex(where: { $0.id == subtask.projectId }) {
            if let subTaskIndex = projects[projectIndex].subTasks.firstIndex(where: { $0.id == subtask.id }) {
                model.updateSubTask(atProjectIndex: projectIndex, atSubTaskIndex: subTaskIndex, subTask: subtask)
                loadProjects()
            }
        }
    }
    
    func deleteSubTask(project: Project, subTask: SubTask) {
        if let projectIndex = projects.firstIndex(where: { $0.id == project.id }) {
            if let subTaskIndex = projects[projectIndex].subTasks.firstIndex(where: { $0.id == subTask.id }) {
                model.deleteSubTask(atProjectIndex: projectIndex, atSubTaskIndex: subTaskIndex)
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

