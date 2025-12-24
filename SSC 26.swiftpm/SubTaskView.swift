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
        if project != nil {
            return project!.subTasks.first(where: { $0.id == subTaskId })
        } else {
            return nil
        }
    }
    
    var body: some View {
        if subTask != nil {
            HStack {
                Text(subTask!.title)
                Button(action: { viewModel.completeSubTask(subtask: subTask!) }) { //FIXME: add haptic and confetti
                    if #available(iOS 17.0, *) {
                        Image(systemName: subTask!.isComplete ? "checkmark.circle.fill" : "circle")
                            .contentTransition(.symbolEffect(.replace))
                            .tint(.primary)
                    } else {
                        Image(systemName: subTask!.isComplete ? "checkmark.circle.fill" : "circle")
                            .tint(.primary)
                    }
                }
            }
        }
    }
}
