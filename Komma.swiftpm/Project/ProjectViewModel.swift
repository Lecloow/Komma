//
//  ProjectViewModel.swift
//  Kómma
//
//  Created by Thomas Conchon on 12/6/25.
//

import Foundation
import SwiftUI
import UniformTypeIdentifiers


@MainActor
class ProjectViewModel: ObservableObject {
    @Published private var model = createProjectModel()
    @Published var confettiSubtasksCounter = 0
    
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
    
    func createDemo() {
        
    }
    
    func binding<Value>(for project: Project, keyPath: WritableKeyPath<Project, Value>) -> Binding<Value> {
        Binding(
            get: { project[keyPath: keyPath] },
            set: { [weak self] newValue in
                var updatedProject = project
                updatedProject[keyPath: keyPath] = newValue
                self?.update(project: updatedProject)
            }
        )
    }
    func bindingTask<Value>(for task: ProjectTask, keyPath: WritableKeyPath<ProjectTask, Value>) -> Binding<Value> {
        Binding(
            get: { task[keyPath: keyPath] },
            set: { [weak self] newValue in
                var updatedTask = task
                updatedTask[keyPath: keyPath] = newValue
                self?.updateTask(task: updatedTask)
            }
        )
    }
    func bindingSubtask<Value>(for subtask: Subtask, keyPath: WritableKeyPath<Subtask, Value>) -> Binding<Value> {
        Binding(
            get: { subtask[keyPath: keyPath] },
            set: { [weak self] newValue in
                var updatedSubtask = subtask
                updatedSubtask[keyPath: keyPath] = newValue
                self?.updateSubtask(subtask: updatedSubtask)
            }
        )
    }
    
    //MARK: - User Intents
    
    func addProject(title: String, description: String, deadline: Date) {
        let newId = (projects.last?.id ?? 0) + 1
        let project: Project = .init(id: newId, title: title, description: description, status:  Status.inProgress, priority: Priority.normal, tasks: [], deadline: deadline)
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
    
    func addTask(projectId: Project.ID, title: String, description: String, deadline: Date) {
        if let index = projects.firstIndex(where: { $0.id == projectId }) {
            let newId = (projects[index].tasks.last?.id ?? 0) + 1
            let task = ProjectTask(id: newId, projectId: projectId, title: title, description: description, deadline: deadline, subtasks: [])
            model.addTask(task, atProjectIndex: index)
            loadProjects()
        }
    }
    
    func updateTask(task: ProjectTask) {
        if let projectIndex = projects.firstIndex(where: { $0.id == task.projectId }) {
            if let taskIndex = projects[projectIndex].tasks.firstIndex(where: { $0.id == task.id }) {
                model.updateTask(atProjectIndex: projectIndex, atTaskIndex: taskIndex, task: task)
                loadProjects()
            }
        }
    }
    
    func deleteTask(_ task: ProjectTask) {
        if let projectIndex = projects.firstIndex(where: { $0.id == task.projectId }) {
            if let taskIndex = projects[projectIndex].tasks.firstIndex(where: { $0.id == task.id }) {
                model.deleteTask(atProjectIndex: projectIndex, atTaskIndex: taskIndex)
                loadProjects()
            }
        }
    }
    
    func addSubtask(task: ProjectTask, title: String) {
        if let projectIndex = projects.firstIndex(where: { $0.id == task.projectId }) {
            if let taskIndex = projects[projectIndex].tasks.firstIndex(where: { $0.id == task.id }) {
                let newId = (projects[projectIndex].tasks[taskIndex].subtasks.last?.id ?? 0) + 1
                let subtask = Subtask(id: newId, projectId: task.projectId, taskId: task.id, title: title, notes: "", isComplete: false)
                model.addSubtasks(atProjectIndex: projectIndex, atTaskIndex: taskIndex, subtask: subtask)
                loadProjects()
            }
        }
    }
    
    func completeSubtask(subtask: Subtask) {
        if let projectIndex = projects.firstIndex(where: { $0.id == subtask.projectId }) {
            if let taskIndex = projects[projectIndex].tasks.firstIndex(where: { $0.id == subtask.taskId }) {
                if let subtaskIndex = projects[projectIndex].tasks[taskIndex].subtasks.firstIndex(where: { $0.id == subtask.id }) {
                    model.completeSubtask(atProjectIndex: projectIndex, atTaskIndex: taskIndex, atSubtaskIndex: subtaskIndex)
                    loadProjects()
                    if projects[projectIndex].tasks[taskIndex].progress == 100 { //FIXME: I don't know why but there is a bug when a subtask is complete and you open the createProjectSubtaskView and you mark this subtask as incomplete, why there is some confetti
                        //Edit: I think I know why there is a bug when the page appear, it triggers the confetti before it load the project, and so before the subtask update to uncomplete
                        confettiSubtasksCounter += 1
                    }
                }
            }
        }
    }
    
    func updateSubtask(subtask: Subtask) {
        if let projectIndex = projects.firstIndex(where: { $0.id == subtask.projectId }) {
            if let taskIndex = projects[projectIndex].tasks.firstIndex(where: { $0.id == subtask.taskId }) {
                if let subtaskIndex = projects[projectIndex].tasks[taskIndex].subtasks.firstIndex(where: { $0.id == subtask.id }) {
                    model.updateSubtask(atProjectIndex: projectIndex, atTaskIndex: taskIndex, atSubtaskIndex: subtaskIndex, subtask: subtask)
                    loadProjects()
                }
            }
        }
    }
    
    func moveSubTask(in task: ProjectTask, from source: IndexSet, to destination: Int) {
        if let projectIndex = projects.firstIndex(where: { $0.id == task.projectId }) {
            if let taskIndex = projects[projectIndex].tasks.firstIndex(where: { $0.id == task.id }) {
                model.moveSubtask(atProjectIndex: projectIndex, atTaskIndex: taskIndex, from: source, to: destination)
                loadProjects()
            }
        }
    }
    
    func deleteSubtask(subtask: Subtask) {
        if let projectIndex = projects.firstIndex(where: { $0.id == subtask.projectId }) {
            if let taskIndex = projects[projectIndex].tasks.firstIndex(where: { $0.id == subtask.taskId }) {
                if let subtaskIndex = projects[projectIndex].tasks[taskIndex].subtasks.firstIndex(where: { $0.id == subtask.id }) {
                    model.deleteSubtask(atProjectIndex: projectIndex, atTaskIndex: taskIndex, atSubtaskIndex: subtaskIndex)
                    loadProjects()
                }
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
