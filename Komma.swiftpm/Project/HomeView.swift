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
    @AppStorage("username") var username: String = ""
    
    var body: some View {
        VStack(alignment: .leading) {
            welcomeText
            Divider()
            Text("Projects:")
                .font(.headline)
            projectsCards
            addProjectButton
        }
        .onAppear {
            viewModel.loadProjects()
        }
        .padding()
    }
    
    var welcomeText: some View {
        Group {
            Text("👋, Hey \(username)") //TODO: Sometimes show "👋, Welcome back \(username)"
                .font(.title)
            Text("You have created ^[\(viewModel.projects.count) project](inflect: true). Keep going!") //Pluralize project if there is more than one
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
                    alertContent(project: project)
                } message: {
                    Text("This will permanently delete the project. You can't undo this.")
                }
            }
            .padding(.top)
        }
    }
    
    func alertContent(project: Project) -> some View {
        HStack {
            Button("Cancel", role: .cancel) { }
            Button("Delete Project", role: .destructive) {
                viewModel.delete(project: project)
            }
        }
    }
    
    var addProjectButton: some View {
        HStack {
            Spacer()
            NavigationLink(destination: CreateProjectView(viewModel: viewModel)) {
                VStack {
                    Image(systemName: "plus.app")
                        .font(.system(size: 50))
                    Text("New Project")
                }
                .tint(.primary)
            }
            Spacer()
        }
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

