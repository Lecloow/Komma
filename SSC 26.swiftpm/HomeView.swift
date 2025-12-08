//
//  SwiftUIView.swift
//  SSC 26
//
//  Created by Thomas Conchon on 12/4/25.
//

import SwiftUI
import UniformTypeIdentifiers


struct HomeView: View {
    var viewModel: ProjectViewModel
    @State var showImporter = false
    
    @State private var projects = [ProjectModel.Project]()
    
    var body: some View {
        ScrollView {
            ForEach(projects) { project in
                CardView(project: project)
                    .onTapGesture {
                        viewModel.updateProgress(project: project, progress: 1)
                        projects = viewModel.loadProjects()
                    }
            }
            Button(action: {
                let project: ProjectModel.Project = .init(id: 0, title: "Sample Project", description: "No description", progress: 0, deadline: "08-02-2026")
                viewModel.addProject(project)
                projects = viewModel.loadProjects()
            }) {
                VStack {
                    Image(systemName: "plus.app")
                        .font(Font.system(size: 50))
                    Text("New Project")
                }
            }
            Button("Exporter") {
                if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                   let root = scene.windows.first?.rootViewController {

                    let projects = viewModel.loadProjects()
                    viewModel.exportProjects(projects, from: root)
                }
            }
            Button("Importer") {
                showImporter = true
            }
            Button("Reset Sample Project") {
                viewModel.resetProjects()
                projects = viewModel.loadProjects()
                showImporter = false
                // rafraîchir la liste
        }
        }
        .sheet(isPresented: $showImporter) {
            ImportJSONView { url in
                viewModel.importProjects(from: url)
                projects = viewModel.loadProjects() // refresh UI
            }
        }
        .onAppear {
            //projects = viewModel.decode()
            projects = viewModel.loadProjects()
        }
    }
}

struct CardView: View {
    typealias Project = ProjectModel.Project
    
    let project: Project
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 12)
                .fill(.white)
                .aspectRatio(32/9, contentMode: .fit)
            RoundedRectangle(cornerRadius: 12)
                .stroke(.gray)
                .aspectRatio(32/9, contentMode: .fit)
            HStack {
                VStack(alignment: .leading) {
                    Text(project.title)
                        .font(.title)
                    Text("Deadline: \(project.deadline)")
                    Text(project.description)
                        .font(.caption)
                }
                Spacer()
                VStack {
                    Text("\(project.progress)")
                    Image(systemName: "progress.indicator")
                }
            }
            .padding()
        }
        .padding(.horizontal)
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
