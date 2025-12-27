//
//  CreateProjectView.swift
//  SSC 26
//
//  Created by Thomas Conchon on 12/16/25.
//

import SwiftUI

struct CreateProjectView: View {
    @ObservedObject var viewModel: ProjectViewModel
    @Environment(\.dismiss) private var dismiss
    
    @State var projectId: Project.ID?
        
    private var project: Project? {
        guard let id = projectId else { return nil }
        return viewModel.projects.first(where: { $0.id == id })
    }
        
    var body: some View {
        VStack {
            if let project = project { 
                VStack(alignment: .leading) {
                    TextField("Untitled Project", text: Binding(
                        get: { project.title },
                        set: { newValue in
                            var updatedProject = project
                            updatedProject.title = newValue
                            viewModel.update(project: updatedProject)
                        }
                    ))
                    .font(.largeTitle)
                    Divider()
                    EditProjectInformation(viewModel: viewModel, project: project)
                    Divider()
                    subtasks
                    Spacer()
                }
                .toolbar { toolbar }
                .multilineTextAlignment(.leading)
                .padding()
            }
        }
        .onAppear {
            if projectId == nil {
                viewModel.addProject(title: "", description: "", deadline: Date())
                projectId = viewModel.projects.last?.id
            }
        }
    }
        
    var subtasks: some View {
        VStack(alignment: .leading) {
            if let project = project {
                Button(action: { viewModel.addSubtask(project: project, title: "") }) {
                    Text("Add subtask")
                }
                List {
                    ForEach(project.subtasks) { subTask in
                        SubtaskView(mode: .edit, viewModel: viewModel, subtask: subTask)
                            .listRowInsets(EdgeInsets())
                    }
                }
                .listStyle(.plain)
                .scrollContentBackground(. hidden)
            }
        }
    }
    
    var toolbar: some ToolbarContent {
        ToolbarItem(placement: .navigationBarTrailing) {
            if #available(iOS 26.0, *) {
                button
                .buttonStyle(.glassProminent)
            } else {
                button
                .buttonStyle(.borderedProminent)
            }
        }
    }
    var button: some View {
        Button(action: { dismiss() }) {
            Image(systemName: "checkmark")
        }
        .tint(.primary)
    }
}


struct EditProjectInformation: View {
    @ObservedObject var viewModel: ProjectViewModel
    var project: Project
    
    var body: some View {
        TextField("Description", text: Binding(
            get: { project.description },
            set: { newValue in
                var updatedProject = project
                updatedProject.description = newValue
                viewModel.update(project: updatedProject)
            }
        ))
        date
        status
        priority
    }
    
    var date: some View {
        DatePicker(
            "Deadline",
            selection: Binding(
                get: { project.deadline },
                set: { newValue in
                    var updatedProject = project
                    updatedProject.deadline = newValue
                    viewModel.update(project: updatedProject)
                }
            ),
            displayedComponents: [.date]
        )
    }
    var status: some View {
        Picker("Change Status", selection: Binding(
            get: { project.status },
            set: { newValue in
                var updatedProject = project
                updatedProject.status = newValue
                viewModel.update(project: updatedProject)
            }
        )) {
            Text("Later").tag(Status.later)
            Text("On Hold").tag(Status.onHold)
            Text("In Progress").tag(Status.inProgress)
            Text("In Review").tag(Status.inReview)
            Text("Done").tag(Status.done)
        }
    }
    var priority: some View {
        Picker("Change Priority", selection: Binding(
            get: { project.priority },
            set: { newValue in
                var updatedProject = project
                updatedProject.priority = newValue
                viewModel.update(project: updatedProject)
            }
        )) {
            Text("Low").tag(Priority.low)
            Text("Normal").tag(Priority.normal)
            Text("High").tag(Priority.high)
            Text("Urgent").tag(Priority.urgent)
        }
    }
}
