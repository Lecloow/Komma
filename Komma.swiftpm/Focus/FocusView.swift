//
//  FocusView.swift
//  Kómma
//
//  Created by Thomas Conchon on 12/22/25.
//

import SwiftUI

struct FocusView: View {
    @ObservedObject var viewModel: FocusViewModel
    @ObservedObject var projectViewModel: ProjectViewModel
    
    var body: some View {
//        Text("Focus View")
//        Button(action: { viewModel.startSession() }) {
//            Text("Start timer")
//        }
//        Text(formatTime(viewModel.session.elapsedTime))
//            .font(.system(size: 40, weight: .bold))
//        Button(action: { viewModel.stopSession() }) {
//            Text("Stop")
//        }
//        Button(action: { viewModel.resetTimer() }) {
//            Text("Reset")
//        }
        VStack(alignment: .leading) {
            Text("Which project are we focusing on today?")
                .font(.title)
            Spacer()
            projects
            Spacer()
        }
        .padding()
        
    }
    
    var projects: some View {
        ForEach(projectViewModel.projects) { project in //TODO: Sort by progress and by due date
            NavigationLink(destination: ChooseTaskView(project: project)) {
                Text(project.title)
            }
        }
    }
    
    
    func formatTime(_ seconds: Int) -> String {
        let minutes = seconds / 60
        let secs = seconds % 60
        return String(format: "%02d:%02d", minutes, secs)
    }
}

struct ChooseTaskView: View {
    let project: Project
    
    var body: some View {
        VStack {
            Text("Now select a task to focus on!")
            tasks
        }
    }
    
    var tasks: some View {
        ForEach(project.tasks) { task in //TODO: Sort by progress and by due date
            NavigationLink(destination: SelectSubtasksView(task: task)) { //TODO: Next Slide
                Text(task.title)
            }
        }
    }
}

struct SelectSubtasksView: View {
    let task: ProjectTask
    
    var body: some View {
        Text("Hello, World!")
        subtasks
        if #available(iOS 26.0, *) {
            button
                .buttonSizing(.flexible)
                .buttonStyle(.glassProminent)
                .padding()
        } else {
            button
                .buttonStyle(.borderedProminent)
                .padding()
        }
    }

    
    var subtasks: some View {
        List {
            ForEach(task.subtasks) { subtask in
                subtaskView(subtask: subtask)
            }
        }
        .listStyle(.plain)
        .scrollContentBackground(. hidden)
    }

    var button: some View {
        Button(action: { /*TODO: Launch Session*/ }) {
            Text("Start Focusing!")
        }
        .tint(.primary)
    }
}

struct subtaskView: View {
    var subtask: Subtask
    @State var isSelected: Bool = false
    
    var body: some View {
        HStack {
            Text(subtask.title)
            Spacer()
            selectButton
        }
    }
    
    var selectButton: some View {
        Button(action: { isSelected.toggle() }) {
            if #available(iOS 17.0, *) {
                Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                    .contentTransition(.symbolEffect(.replace))
                    .tint(.primary)
            } else {
                Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                    .tint(.primary)
            }
        }
    }
}
