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
        NavigationStack {
            ScrollView {
                ForEach(viewModel.projects) { project in
                    NavigationLink(destination: ProjectView(project: project)) {
                        CardView(project: project)
                            .tint(.primary)
                    }
                }
                NavigationLink(destination: CreateProjectView(viewModel: viewModel)) {
                    VStack {
                        Image(systemName: "plus.app")
                            .font(Font.system(size: 50))
                        Text("New Project")
                    }
                    .tint(.primary)
                }
            }
        }
        .onAppear {
            viewModel.loadProjects()
        }
    }
}

