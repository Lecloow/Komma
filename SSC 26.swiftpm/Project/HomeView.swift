//
//  HomeView.swift
//  SSC 26
//
//  Created by Thomas Conchon on 12/4/25.
//

import SwiftUI


struct HomeView: View {
    @ObservedObject var viewModel: ProjectViewModel
    
    var body: some View {
        VStack {
            cards
            NavigationLink(destination: CreateProjectView(viewModel: viewModel)) {
                VStack {
                    Image(systemName: "plus.app")
                        .font(Font.system(size: 50))
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
    
    var cards: some View {
        ScrollView {
            ForEach(viewModel.projects) { project in
                NavigationLink(destination: ProjectView(viewModel: viewModel, project: project)) {
                    CardView(project: project) //FIXME: Too close to the top
                        .tint(.primary)
                        .contextMenu { //FIXME: Don't know why but a lot of bug
                            projectContextMenu(for: project)
                        }
                }
            }
            .padding(.top) //FIXME: Maybe too much
        }
        .padding(.top)
    }
    
    @ViewBuilder
    private func projectContextMenu(for project: Project) -> some View {
        NavigationLink(destination: ProjectView(viewModel: viewModel, project: project)) {
            Label("Edit Project", systemImage: "square.and.pencil")
        }
        Divider()
        Button {
            // Open Maps and center it on this item.
        } label: {
            Label("Show in Maps", systemImage: "mappin")
        }
    }
}

