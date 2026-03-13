//
//  TimerView.swift
//  Kómma
//
//  Created by Thomas Conchon on 1/15/26.
//

import SwiftUI

struct TimerView: View { // Finally the real focus view
    var viewModel: FocusViewModel
    
    var body: some View {
        VStack {
            ForEach(viewModel.selectedSubtasks) { subtask in
                if let subtask = viewModel.session.subtasks.first(where: { $0.id == subtask.id }) {
                    Text(subtask.title)
                } else {
                    Text("Subtask not found")
                }
            }
            Text(formatTime(Int(viewModel.estimatedTime)))
        }
        .onAppear() {
            viewModel.startSession()
        }
    }
    func formatTime(_ seconds: Int) -> String {
        let minutes = seconds / 60
        let secs = seconds % 60
        return String(format: "%02d:%02d", minutes, secs)
    }
}

#Preview {
    TimerView(viewModel: FocusViewModel())
}
