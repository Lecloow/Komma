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
    typealias Project = ProjectModel.Project
    
    private static func createProjectModel() -> ProjectModel {
        ProjectModel()
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
    func addProject(_ project: Project) {
        model.addProject(project)
    }
    func updateProgress(project: Project, progress: Int) {
        model.updateProgress(project: project, progress: progress)
    }
    

    @MainActor func exportProjects(_ projects: [Project], from vc: UIViewController) {
        model.exportProjects(projects, from: vc)
    }
    
    func resetProjects() {
        UserDefaults.standard.removeObject(forKey: "projects")
    }
    
    func importProjects(from url: URL) {
        model.importProjects(from: url)
    }
    
    //MARK: - User Intents
    func choose(project: Project) {
        
    }
    func update(project: Project) {
        
    }
}
 //TODO: Rewrite this shit




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
