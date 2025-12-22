//
//  ProjectView.swift
//  SSC 26
//
//  Created by Thomas Conchon on 12/8/25.
//

import SwiftUI

struct ProjectView: View {
    @ObservedObject var viewModel: ProjectViewModel
    var project: Project
    @Environment(\.dismiss) private var dismiss
    
    @State var isShowingDeletePopup = false

    var body: some View {
        VStack(alignment: .leading) {
            Text(project.title)
                .font(.largeTitle)
            Divider()
            Text(project.description)
            Text("\(project.deadline.formatted(date: .abbreviated, time: .omitted))")
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
            
            switch project.priority {
            case .low:
                Text("Low").foregroundStyle(.blue)
            case .normal:
                Text("Normal").foregroundStyle(.green)
            case .high:
                Text("High").foregroundStyle(.orange)
            case .urgent:
                Text("Urgent").foregroundStyle(.red)
            }
            //TODO: The Text is not supposed to be in Color but the back is. Color inspired from Notion (pastel)
            Text("Progress: \(project.progress)")
            Divider()
            ForEach(project.subTasks) { subTask in
                SubTaskView(viewModel: viewModel, projectId: project.id, subTaskId: subTask.id)
            }
            Spacer()
        }
        .alert("Delete Project ?", isPresented: $isShowingDeletePopup) {
            Button("Cancel", role: .cancel) { }
            Button("Delete Project", role: .destructive) {
                viewModel.delete(project: project)
                dismiss()
            }
        } message: {
            Text("This will permanently delete the project. You can't undo this.")
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                HStack {
                    NavigationLink(destination: CreateProjectView(viewModel: viewModel, projectId: project.id)) {
                        Image(systemName: "square.and.pencil")
                    }
                    Menu {
                        Button(role: .destructive) { isShowingDeletePopup = true } label: {
                            Label("Delete Project", systemImage: "trash")
                        }

                        Button {
                            // autre action
                        } label: {
                            Label("IDK", systemImage: "mappin")
                        }

                    } label: {
                        Image(systemName: "gear")
                    }
                }
            }
        } //TODO: Button Delete etc...
        .multilineTextAlignment(.leading)
        .padding()
    }
}

//FIXME: Clean this shit
