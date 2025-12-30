//
//  CreateTaskView.swift
//  Kómma
//
//  Created by Thomas Conchon on 12/29/25.
//

import SwiftUI

struct CreateTaskView: View {
    @ObservedObject var viewModel: ProjectViewModel
    @Environment(\.dismiss) private var dismiss
    @State var isShowingDeletePopup = false

    
    @State var taskId: ProjectTask.ID?
    var projectId: Project.ID
    
    var projectIndex: Int? {
        viewModel.projects.firstIndex(where: { $0.id == projectId})
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
                    subtasks
                    Spacer()
                }
                .multilineTextAlignment(.leading)
                .padding()
                .toolbar { toolbar }
            }
        }
        .alert("Delete Task ?", isPresented: $isShowingDeletePopup) {
            alertContent
        } message: {
            Text("This will permanently delete the task. You can't undo this.")
        }
        .onAppear {
            if taskId == nil {
                viewModel.addTask(projectId: projectId, title: "", description: "", deadline: Date())
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
    
    var alertContent: some View {
        HStack {
            Button("Cancel", role: .cancel) { }
            if let task = task {
                Button("Delete Task", role: .destructive) {
                    viewModel.deleteTask(task)
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
                Label("Delete Task", systemImage: "trash")
            }
            Button(action: { dismiss() }) {
                Image(systemName: "checkmark")
            }
        }
        .tint(.primary)
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
        progress
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
    var progress: some View {
            VStack(alignment: .leading) {
                Text("Progress: \(task.progress)%")
                ProgressView(value: Double(task.progress)/100)
                    .tint(.primary)
                    .animation(.easeInOut, value: task.progress)
            }
        }
}
