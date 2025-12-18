//
//  ProjectView.swift
//  SSC 26
//
//  Created by Thomas Conchon on 12/8/25.
//

import SwiftUI

struct ProjectView: View {
    @ObservedObject var viewModel: ProjectViewModel
    var project: ProjectManager.Project
    
    @State var isShowingDeletePopup = false

    var body: some View {
        VStack(alignment: .leading) {
            Text(project.title)
                .font(.largeTitle)
            Divider()
            Text(project.description)
            Text("\(project.deadline.formatted(date: .abbreviated, time: .omitted))")
            //Text(project.deadline)
            //Text(project.status)
            switch project.status {
            case .later:
                Text("later").foregroundStyle(.gray)
            case .onHold:
                Text("on Hold").foregroundStyle(.red)
            case .inProgress:
                Text("in Progress").foregroundStyle(.blue)
            case .inReview:
                Text("In Review").foregroundStyle(.orange)
            case .done:
                Text("Done").foregroundStyle(.green)
            }
            //TODO: The Text is not supposed to be in Color but the back is. Color inspired from Notion (pastel)
            Text("Progress: \(project.progress)")
            Spacer()
        }
        .alert("Delete Project ?", isPresented: $isShowingDeletePopup) {
            Button("Cancel", role: .cancel) { }
            Button("Delete Project", role: .destructive) {
                viewModel.delete(project: project, )
                viewModel.loadProjects() //FIXME: Do we need this line ?
            }
        } message: {
            Text("This will permanently delete the project. You can't undo this.")
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                NavigationLink(destination: CreateProjectView(viewModel: viewModel, project: project)) {
                    Image(systemName: "square.and.pencil")
                }
                Button(action: { }) {
                    Image(systemName: "trash")
                }
            }
        } //TODO: Button Delete etc...
        .multilineTextAlignment(.leading)
        .padding()
    }
}
