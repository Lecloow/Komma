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
                    TextField("Untitled Task", text: viewModel.bindingTask(for: task, keyPath: \.title))
                    .font(.largeTitle)
                    Divider()
                    EditTaskInformation(viewModel: viewModel, task: task)
                    Divider()
                    Text("Subtasks:")
                        .font(.headline)
                        .padding(.bottom, 10)
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
        Group {
            if let task = task {
                Button(action: { viewModel.addSubtask(task: task, title: "") }) { //TODO: Add design
                    Label("Add subtask", systemImage: "plus")
                }
                List {
                    ForEach(task.subtasks) { subtask in
                        SubtaskView(mode: .edit, viewModel: viewModel, subtask: subtask)
                            .listRowInsets(EdgeInsets())
                    }
                    .onDelete { indexSet in
                        if let index = indexSet.first {
                            let subtask = task.subtasks[index]
                            viewModel.deleteSubtask(subtask: subtask)
                        }
                    }  //FIXME: onDelete swipe action is broken
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
        TextField("Description", text: viewModel.bindingTask(for: task, keyPath: \.description))
        date
        progress
    }
    
    var date: some View {
        DatePicker(
            "Deadline",
            selection: viewModel.bindingTask(for: task, keyPath: \.deadline),
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
