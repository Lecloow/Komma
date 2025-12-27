//
//  SubtaskView.swift
//  SSC 26
//
//  Created by Thomas Conchon on 12/20/25.
//

import SwiftUI

struct SubtaskView: View {
    var mode: Mode
    @ObservedObject var viewModel: ProjectViewModel
    var subtask: Subtask
        
    var body: some View {
        switch mode {
        case .edit:
            TextField("Untitled Subtask", text: Binding(
                get: { subtask.title },
                set: { newValue in
                    var updatedSubtask = subtask
                    updatedSubtask.title = newValue
                    viewModel.updateSubtask(subtask: updatedSubtask)
                }
            ))
            .transformToSubtaskView(viewModel: viewModel, subtask: subtask)
            .swipeActions(edge: .trailing) {
                Button(role: .destructive) {
                    viewModel.deleteSubtask(subtask: subtask)
                } label: {
                    Label("Delete", systemImage: "trash")
                }
            }
        case .view:
            Text(subtask.title)
                .transformToSubtaskView(viewModel: viewModel, subtask: subtask)
                .swipeActions(edge: .trailing) {
                    Button {
                        viewModel.completeSubtask(subtask: subtask)
                    } label: {
                        Label(subtask.isComplete ? "Undo" : "Done", systemImage: subtask.isComplete ? "xmark" : "checkmark")
                    }
                    .tint(subtask.isComplete ? .gray : .green)
                }
        }
    }
}

enum Mode {
    case edit, view
}

struct TransformToSubtaskView: ViewModifier {
    @ObservedObject var viewModel: ProjectViewModel
    var subtask: Subtask
    
    func body(content: Content) -> some View {
        HStack {
            content
            Spacer()
            Button(action: { viewModel.completeSubtask(subtask: subtask) }) { //FIXME: add haptic and confetti
                if #available(iOS 17.0, *) {
                    Image(systemName: subtask.isComplete ? "checkmark.circle.fill" : "circle")
                        .contentTransition(.symbolEffect(.replace))
                        .tint(.primary)
//                        .sensoryFeedback(.impact(flexibility: .soft, intensity: 0.5), trigger: viewModel.confettiCounter)
                        .sensoryFeedback(.success, trigger: viewModel.confettiCounter)
                } else {
                    Image(systemName: subtask.isComplete ? "checkmark.circle.fill" : "circle")
                        .tint(.primary)
                }
            }
            .padding(.horizontal)
        }
    }
}

extension View {
    func transformToSubtaskView(viewModel: ProjectViewModel, subtask: Subtask) -> some View {
        modifier(TransformToSubtaskView(viewModel: viewModel, subtask: subtask))
    }
}
