//
//  SwiftUIView.swift
//  SSC 26
//
//  Created by Thomas Conchon on 12/4/25.
//

import SwiftUI

struct HomeView: View {
    var viewModel: ProjectViewModel
    
    @State private var projects = [ProjectModel.Project]()
    
    var body: some View {
        ScrollView {
            ForEach(projects) { project in
                CardView(project: project)
            }
            Button(action: {}) {
                VStack {
                    Image(systemName: "plus.app")
                        .font(Font.system(size: 50))
                    Text("New Project")
                }
            }
        }
        .onAppear {
            projects = viewModel.decode()
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

