//
//  TaskView.swift
//  Kómma
//
//  Created by Thomas Conchon on 12/29/25.
//

import SwiftUI

struct TaskView: View {
    @ObservedObject var viewModel: ProjectViewModel
    @Environment(\.dismiss) private var dismiss
    @State var isShowingDeletePopup = false
    var task: ProjectTask
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(task.title)
                .font(.largeTitle)
            Divider()
            TaskInformation(task: task)
            Divider()
            Text("Subtasks:")
                .font(.headline)
                .padding(.bottom, -10)
            subtasks
        }
        .padding()
        .alert("Delete Task ?", isPresented: $isShowingDeletePopup) {
            alertContent
        } message: {
            Text("This will permanently delete the task. You can't undo this.")
        }
        .toolbar {
            toolbar
        }
    }
    
    var subtasks: some View {
        List {
            ForEach(task.subtasks) { subTask in
                SubtaskView(viewModel: viewModel, subtask: subTask)
                    .listRowInsets(EdgeInsets())
            }
        }
        .listStyle(. plain)
        .scrollContentBackground(.hidden)
    }
    
    var alertContent: some View {
        HStack {
            Button("Cancel", role: .cancel) { }
            Button("Delete Task", role: .destructive) {
                viewModel.deleteTask(task)
                dismiss()
            }
        }
    }
    
    var toolbar: some ToolbarContent {
        ToolbarItem(placement: .navigationBarTrailing) {
            HStack {
                NavigationLink(destination: CreateTaskView(viewModel: viewModel, taskId: task.id, projectId: task.projectId)) {
                    Image(systemName: "square.and.pencil")
                }
                Menu {
                    NavigationLink(destination: CreateTaskView(viewModel: viewModel, taskId: task.id, projectId: task.projectId))  {
                        Label("Edit Project", systemImage: "square.and.pencil")
                    }
                    Button(action: { }) { //TODO: Star or pin project
                        Label("Add to favorites", systemImage: "plus")
                    }
                    Divider()
                    Button(role: .destructive, action: { isShowingDeletePopup = true }) {
                        Label("Delete Project", systemImage: "trash")
                    }
                } label: {
                    Image(systemName: "ellipsis")
                }
            }
        }
    }
}

struct CardForTaskView: View {
    var mode: Mode = .view
    @ObservedObject var viewModel: ProjectViewModel
    @Environment(\.dismiss) private var dismiss
    var task: ProjectTask
    var project: Project
    
    var body: some View {
        switch mode {
        case .view:
            NavigationLink(destination: TaskView(viewModel: viewModel, task: task)) {
                Text(task.title)
            }
        case .edit:
            NavigationLink(destination: CreateTaskView(viewModel: viewModel, taskId: task.id, projectId: project.id)) {
                Text(task.title)
            }
        }
    }
}

struct TaskInformation: View {
    var task: ProjectTask
    
    var body: some View {
        Text(task.description)
        Text("\(task.deadline.formatted(date: .long, time: .omitted))")
        Text("Progress: \(task.progress)%")
        ProgressView(value: Double(task.progress)/100)
            .tint(.primary)
            .animation(.easeInOut, value: task.progress)
    }
}
