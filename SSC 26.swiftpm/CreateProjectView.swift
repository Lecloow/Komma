//
//  CreateProjectView.swift
//  SSC 26
//
//  Created by Thomas Conchon on 12/16/25.
//

import SwiftUI

//FIXME: Clean this code

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
                    EditSubTask(viewModel: viewModel, project: project)
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
        
    var toolbar: some ToolbarContent {
        ToolbarItem(placement: .navigationBarTrailing) {
            if #available(iOS 26.0, *) {
                Button(action: { dismiss() }) {
                    Image(systemName: "checkmark")
                }
                .buttonStyle(.glassProminent)
                .tint(.primary)
            } else {
                Button(action: { dismiss() }) {
                    Image(systemName: "checkmark")
                }
                .buttonStyle(.borderedProminent)
                .tint(.primary)
            }
        }
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

struct EditSubTask: View {
    @ObservedObject var viewModel: ProjectViewModel
    var project: Project
    
    
    var body: some View {
        VStack(alignment: .leading) {
            Button(action: { viewModel.addSubTask(project: project, title: "Subtask") }) {
                Text("Add subtask")
            }
            subtasks
        }
    }
    var subtasks: some View {
        List {
            ForEach(project.subTasks) { subTask in
                EditSubTaskView(viewModel: viewModel, projectId: project.id, subTaskId: subTask.id)
                    .listRowInsets(EdgeInsets())
            }
        }
        .listStyle(. plain)
        .scrollContentBackground(.hidden)
    }
}
//TODO: Create a ViewModifier Instead
