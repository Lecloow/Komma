//
//  CreateProjectView.swift
//  Kómma
//
//  Created by Thomas Conchon on 12/16/25.
//

import SwiftUI

struct CreateProjectView: View {
    @ObservedObject var viewModel: ProjectViewModel
    @Environment(\.dismiss) private var dismiss
    @State var isShowingDeletePopup = false
    
    @State var projectId: Project.ID?
        
    private var project: Project? {
        guard let id = projectId else { return nil }
        return viewModel.projects.first(where: { $0.id == id })
    }
        
    var body: some View {
        VStack {
            if let project = project { 
                VStack(alignment: .leading) {
                    TextField("Untitled Project", text: viewModel.binding(for: project, keyPath: \.title))
                        .font(.largeTitle)
                    Divider()
                    EditProjectInformation(viewModel: viewModel, project: project)
                    Divider()
                    tasks
                    Spacer()
                }
                .toolbar { toolbar }
                .multilineTextAlignment(.leading)
                .padding()
            }
        }
        .alert("Delete Project ?", isPresented: $isShowingDeletePopup) {
            alertContent
        } message: {
            Text("This will permanently delete the project. You can't undo this.")
        }
        .onAppear {
            if projectId == nil {
                viewModel.addProject(title: "", description: "", deadline: Date())
                projectId = viewModel.projects.last?.id
            }
        }
    }
        
    var tasks: some View {
        VStack(alignment: .leading) {
            if let project = project {
                NavigationLink(destination: CreateTaskView(viewModel: viewModel, projectId: project.id)) {
                    HStack {
                        Image(systemName: "plus.app")
                            .font(Font.system(size: 20))
                        Text("New Task")
                    }
                    .tint(.primary)
                }
                List {
                    ForEach(project.tasks) { task in
                        CardForTaskView(mode: .edit, viewModel: viewModel, task: task, project: project)
                            .tint(.primary)
                            .listRowInsets(EdgeInsets())
                            .contextMenu {
                                NavigationLink(destination: CreateTaskView(viewModel: viewModel, taskId: task.id, projectId: task.projectId)) {
                                    Label("Edit Task", systemImage: "square.and.pencil")
                                }
                            }
                    }
                }
                .listStyle(. plain)
                .scrollContentBackground(.hidden)
            }
        }
    }
    
    var alertContent: some View {
        HStack {
            Button("Cancel", role: .cancel) { }
            if let project = project {
                Button("Delete Project", role: .destructive) {
                    viewModel.delete(project: project)
                    dismiss()
                }
            }
        }
    }
    
    var toolbar: some ToolbarContent {
        ToolbarItem(placement: .navigationBarTrailing) {
            HStack {
                if #available(iOS 26.0, *) {
                    buttons.buttonStyle(.glassProminent)
                } else {
                    buttons.buttonStyle(.borderedProminent)
                }
            }
        }
    }
    var buttons: some View {
        HStack {
            Button(role: .destructive, action: { isShowingDeletePopup = true }) {
                Label("Delete Project", systemImage: "trash")
            }
            Button(action: { dismiss() }) {
                Image(systemName: "checkmark")
            }
        }
        .tint(.primary)
    }
}


struct EditProjectInformation: View {
    @ObservedObject var viewModel: ProjectViewModel
    var project: Project
    
    var body: some View {
        TextField("Description", text: viewModel.binding(for: project, keyPath: \.description))
        date
        status
        priority
        progress
    }
    
    var date: some View {
        DatePicker(
            "Deadline",
            selection: viewModel.binding(for: project, keyPath: \.deadline),
            displayedComponents: [.date]
        )
    }
    var status: some View {
        Picker("Change Status", selection: viewModel.binding(for: project, keyPath: \.status)) {
            Text("Later").tag(Status.later)
            Text("On Hold").tag(Status.onHold)
            Text("In Progress").tag(Status.inProgress)
            Text("In Review").tag(Status.inReview)
            Text("Done").tag(Status.done)
        }
    }
    var priority: some View {
        Picker("Change Priority", selection: viewModel.binding(for: project, keyPath: \.priority)) {
            Text("Low").tag(Priority.low)
            Text("Normal").tag(Priority.normal)
            Text("High").tag(Priority.high)
            Text("Urgent").tag(Priority.urgent)
        }
    }
    var progress: some View {
        VStack(alignment: .leading) {
            Text("Progress: \(project.progress)%")
            ProgressView(value: Double(project.progress)/100)
                .tint(.primary)
                .animation(.easeInOut, value: project.progress)
        }
    }

}
