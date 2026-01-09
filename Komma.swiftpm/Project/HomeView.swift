//
//  HomeView.swift
//  Kómma
//
//  Created by Thomas Conchon on 12/4/25.
//

import SwiftUI


struct HomeView: View {
    @ObservedObject var viewModel: ProjectViewModel
    @State var isShowingDeletePopup = false
    
    var body: some View {
        VStack {
            //TODO: Text here to explain
            Text("👋, Hey, it's nice too see you again")
                .font(.largeTitle)
            Text("You have \(viewModel.projects.count) projects for the moment") //TODO: S if there is more than one
            Divider()
            Text("Projects:")
                .font(.headline)
            projectsCards
            NavigationLink(destination: CreateProjectView(viewModel: viewModel)) {
                VStack {
                    Image(systemName: "plus.app")
                        .font(.system(size: 50))
                    Text("New Project")
                }
                .tint(.primary)
            }
            .padding()
        }
        .onAppear {
            viewModel.loadProjects()
        }
    }
    
    var projectsCards: some View {
        ScrollView {
            ForEach(viewModel.projects) { project in
                NavigationLink(destination: ProjectView(viewModel: viewModel, project: project)) {
                    CardView(project: project)
                        .tint(.primary)
                        .contextMenu { //FIXME: Don't know why but a lot of bug
                            projectContextMenu(for: project)
                        }
                }
                .alert("Delete Project ?", isPresented: $isShowingDeletePopup) {
                    HStack {
                        Button("Cancel", role: .cancel) { }
                        Button("Delete Project", role: .destructive) {
                            viewModel.delete(project: project)
                        }
                    }
                } message: {
                    Text("This will permanently delete the project. You can't undo this.")
                }
            }
            .padding(.top)
        }
        .padding(.top)
        
    }
    
    @ViewBuilder
    private func projectContextMenu(for project: Project) -> some View {
        NavigationLink(destination: ProjectView(viewModel: viewModel, project: project)) {
            Label("Edit Project", systemImage: "square.and.pencil")
        }
        Divider()
        Button(role: .destructive) {
            isShowingDeletePopup = true
        } label: {
            Label("Delete Project", systemImage: "trash")
        }
    }
}

