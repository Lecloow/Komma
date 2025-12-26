//
//  SubTaskView.swift
//  SSC 26
//
//  Created by Thomas Conchon on 12/20/25.
//

import SwiftUI

struct SubTaskView: View {
    @ObservedObject var viewModel: ProjectViewModel
    @State var projectId: Int?
    @State var subTaskId: SubTask.ID
        
    private var project: Project? {
        guard let id = projectId else { return nil }
        return viewModel.projects.first(where: { $0.id == id })
    }
    private var subTask: SubTask? {
        return project?.subTasks.first(where: { $0.id == subTaskId })
    }
    
    var body: some View {
        if subTask != nil && project != nil {
            Text(subTask!.title)
                .transformToSubtaskView(viewModel: viewModel, project: project!, subtaskId: subTaskId)
        }
    }
}

struct EditSubTaskView: View {
    @ObservedObject var viewModel: ProjectViewModel
    @State var projectId: Int?
    @State var subTaskId: SubTask.ID
        
    private var project: Project? {
        guard let id = projectId else { return nil }
        return viewModel.projects.first(where: { $0.id == id })
    }
    private var subtask: SubTask? {
        return project?.subTasks.first(where: { $0.id == subTaskId })
    }
    
    var body: some View {
        if project != nil && subtask != nil{
            TextField("Untitled Subtask", text: Binding(
                get: { subtask!.title },
                set: { newValue in
                    var updatedSubtask = subtask!
                    updatedSubtask.title = newValue
                    viewModel.updateSubTask(subtask: updatedSubtask)
                }
            ))
            .transformToSubtaskView(viewModel: viewModel, project: project!, subtaskId: subTaskId)
        }
    }
}

struct TransformToSubtaskView: ViewModifier {
    @ObservedObject var viewModel: ProjectViewModel
    var project: Project
    var subtaskId: SubTask.ID

    private var subtask: SubTask? {
        project.subTasks.first(where: { $0.id == subtaskId })
    }
    
    func body(content: Content) -> some View {
        if let subtask = subtask {
            HStack {
                content
                Button(action: { viewModel.completeSubTask(subtask: subtask) }) { //FIXME: add haptic and confetti
                    if #available(iOS 17.0, *) {
                        Image(systemName: subtask.isComplete ? "checkmark.circle.fill" : "circle")
                            .contentTransition(.symbolEffect(.replace))
                            .tint(.primary)
                    } else {
                        Image(systemName: subtask.isComplete ? "checkmark.circle.fill" : "circle")
                            .tint(.primary)
                    }
                }
            }
        }
    }
}

extension View {
    func transformToSubtaskView(viewModel: ProjectViewModel, project: Project, subtaskId: SubTask.ID) -> some View {
        modifier(TransformToSubtaskView(viewModel: viewModel, project: project, subtaskId: subtaskId))
    }
}
