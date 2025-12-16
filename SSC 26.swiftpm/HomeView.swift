//
//  HomeView.swift
//  SSC 26
//
//  Created by Thomas Conchon on 12/4/25.
//

import SwiftUI


struct HomeView: View {
    @ObservedObject var viewModel: ProjectViewModel
    @State var showProjectView =  false
    @State private var path = NavigationPath()
    
    var body: some View {
        NavigationStack {
            ScrollView {
                ForEach(viewModel.projects) { project in
                    NavigationLink(destination: ProjectView(project: project)) {
                        CardView(project: project)
                    }
                    
                    //                    .onTapGesture {
                    //                        showProjectView.toggle()
                    ////                        viewModel.updateProgress(project: project, progress: 1)
                    //                    }
                    //                    .sheet(isPresented: $showProjectView) {
                    //                        ProjectView(project: project)
                    //                    }
                }
//                Button(action: {
//                    viewModel.addProject(title: "Untitled", description: "Nothing here.", deadline: "08-02-2026")
//                }) {
//                    VStack {
//                        Image(systemName: "plus.app")
//                            .font(Font.system(size: 50))
//                        Text("New Project")
//                    }
//                }
                NavigationLink(destination: CreateProjectView()) {
//                    Button(action: {
//                        //viewModel.addProject(title: "Untitled", description: "Nothing here.", deadline: "08-02-2026")
//                    }) {
                        VStack {
                            Image(systemName: "plus.app")
                                .font(Font.system(size: 50))
                            Text("New Project")
                        }
                    //}
                }
            }
        }
        .onAppear {
            viewModel.loadProjects()
        }
    }
}
