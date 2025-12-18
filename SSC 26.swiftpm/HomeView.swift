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
                ScrollView {
                    ForEach(viewModel.projects) { project in
                        NavigationLink(destination: ProjectView(viewModel: viewModel, project: project)) {
                            CardView(project: project) //FIXME: Too close to the top
                                .tint(.primary)
                        }
                    }
                }
                .padding(.top)
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
}

