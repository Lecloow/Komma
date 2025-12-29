//
//  TaskView.swift
//  SSC 26
//
//  Created by Thomas Conchon on 12/29/25.
//

import SwiftUI

struct TaskView: View {
    @ObservedObject var viewModel: ProjectViewModel
    @Environment(\.dismiss) private var dismiss
    var task: ProjectTask
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(task.title)
                .font(.largeTitle)
            Divider()
            TaskInformation(task: task)
            Divider()
            subtasks
        }
        .padding()
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
            NavigationLink(destination: CreateTaskView(viewModel: viewModel, taskId: task.id, project: project)) {
                Text(task.title)
            }
        }
    }
}

struct TaskInformation: View {
    var task: ProjectTask
    
    var body: some View {
        Text(task.description)
        Text("\(task.deadline.formatted(date: .abbreviated, time: .omitted))")
        Text("Progress: \(task.progress)%")
        ProgressView(value: Double(task.progress)/100)
            .tint(.primary)
            .animation(.easeInOut, value: task.progress)
    }
}
