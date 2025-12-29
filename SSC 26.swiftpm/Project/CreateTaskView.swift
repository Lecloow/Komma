//
//  CreateTaskView.swift
//  SSC 26
//
//  Created by Thomas Conchon on 12/29/25.
//

import SwiftUI

struct CreateTaskView: View {
    @ObservedObject var viewModel: ProjectViewModel
    @Environment(\.dismiss) private var dismiss
    
    @State var taskId: ProjectTask.ID?
    var project: Project
    
    var projectIndex: Int? {
        viewModel.projects.firstIndex(where: { $0.id == project.id})
    }
    
    private var task: ProjectTask? {
        if let index = projectIndex {
            guard let id = taskId else { return nil }
            return viewModel.projects[index].tasks.first(where: { $0.id == id })
        } else {
            return nil
        }
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            if let task = task {
                VStack(alignment: .leading) {
                    TextField("Untitled Task", text: Binding(
                        get: { task.title },
                        set: { newValue in
                            var updatedTask = task
                            updatedTask.title = newValue
                            viewModel.updateTask(task: updatedTask)
                        }
                    ))
                    .font(.largeTitle)
                    Divider()
                    EditTaskInformation(viewModel: viewModel, task: task)
                    Divider()
                    Divider()
                    subtasks
                    Spacer()
                }
                //.toolbar { toolbar }
                .multilineTextAlignment(.leading)
                .padding()
            }
        }
        .onAppear {
            if taskId == nil {
                viewModel.addTask(project: project, title: "", description: "", deadline: Date())
                if let index = projectIndex {
                    taskId = viewModel.projects[index].tasks.last?.id
                }
            }
        }
    }
    
    var subtasks: some View {
        VStack(alignment: .leading) {
            if let task = task {
                Button(action: { viewModel.addSubtask(task: task, title: "") }) {
                    Text("Add subtask")
                }
                List {
                    ForEach(task.subtasks) { subtask in
                        SubtaskView(mode: .edit, viewModel: viewModel, subtask: subtask)
                            .padding(.horizontal)
                            .listRowInsets(EdgeInsets())
                    }
                    .onDelete { indexSet in
                        if let index = indexSet.first {
                            let subtask = task.subtasks[index]
                            viewModel.deleteSubtask(subtask: subtask)
                        }
                    }  // Can't have swipe action and onMove
                    .onMove { oldPosition, newPosition in
                        viewModel.moveSubTask(in: task, from: oldPosition, to: newPosition)
                    }
                }
                .environment(\.editMode, .constant(.active))
                .listStyle(.plain)
                .scrollContentBackground(. hidden)
            }
        }
    }
}

struct EditTaskInformation: View {
    @ObservedObject var viewModel: ProjectViewModel
    var task: ProjectTask
    
    var body: some View {
        TextField("Description", text: Binding(
            get: { task.description },
            set: { newValue in
                var updatedTask = task
                updatedTask.description = newValue
                viewModel.updateTask(task: updatedTask)
            }
        ))
        date
    }
    
    var date: some View {
        DatePicker(
            "Deadline",
            selection: Binding(
                get: { task.deadline },
                set: { newValue in
                    var updatedTask = task
                    updatedTask.deadline = newValue
                    viewModel.updateTask(task: updatedTask)
                }
            ),
            displayedComponents: [.date]
        )
    }
}
