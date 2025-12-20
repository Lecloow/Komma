//
//  EditSubTaskView.swift
//  SSC 26
//
//  Created by Thomas Conchon on 12/20/25.
//

import SwiftUI

struct EditSubTaskView: View {
    @ObservedObject var viewModel: ProjectViewModel
    @State var projectId: Int?
    @State var subTaskId: SubTask.ID
        
    private var project: Project? {
        guard let id = projectId else { return nil }
        return viewModel.projects.first(where: { $0.id == id })
    }
    private var subtask: SubTask? {
        if project != nil {
            return project!.subTasks.first(where: { $0.id == subTaskId })
        } else {
            return nil
        }
    }
    
    var body: some View {
        if project != nil {
            if let subtask = subtask {
                HStack {
                    //Text(subTask!.title)
                    TextField("Untitled Subtask", text: Binding(
                        get: { subtask.title },
                        set: { newValue in
                            var updatedSubtask = subtask
                            updatedSubtask.title = newValue
                            viewModel.updateSubTask(project: project!, subTask: updatedSubtask)
                        }
                    ))
                    Button(action: { viewModel.completeSubTask(project: project!, subTask: subtask) }) { //TODO: add haptic and confetti
                        if #available(iOS 17.0, *) {
                            Image(systemName: subtask.isComplete ? "checkmark.circle.fill" : "circle")
                                .contentTransition(.symbolEffect(.replace))
                        } else {
                            Image(systemName: subtask.isComplete ? "checkmark.circle.fill" : "circle")
                        }
                    }
                }
            }
        }
    }
}
