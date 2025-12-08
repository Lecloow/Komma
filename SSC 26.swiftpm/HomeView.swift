//
//  HomeView.swift
//  SSC 26
//
//  Created by Thomas Conchon on 12/4/25.
//

import SwiftUI


struct HomeView: View {
    @ObservedObject var viewModel: ProjectViewModel
    @State var showImporter = false
    @State var showProjectView =  false
    
    
    var body: some View {
        ScrollView {
            ForEach(viewModel.projects) { project in
                CardView(project: project)
                    .onTapGesture {
                        showProjectView.toggle()
//                        viewModel.updateProgress(project: project, progress: 1)
//                        projects = viewModel.loadProjects()
                    }
                    .sheet(isPresented: $showProjectView) {
                        ProjectView(project: project)
                    }
            }
            Button(action: {
                let project: ProjectModel.Project = .init(id: 0, title: "Sample Project", description: "No description", progress: 0, deadline: "08-02-2026")
                viewModel.addProject(project)
                viewModel.loadProjects()
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
                    viewModel.exportProjects(viewModel.projects, from: root)
                }
            }
            Button("Importer") {
                showImporter = true
            }
            Button("Reset Sample Project") {
                viewModel.resetProjects()
                viewModel.loadProjects()
                showImporter = false
                // rafraîchir la liste
        }
        }
        .sheet(isPresented: $showImporter) {
            ImportJSONView { url in
                viewModel.importProjects(from: url)
                viewModel.loadProjects()
            }
        }
        
        .onAppear {
            viewModel.loadProjects()
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

