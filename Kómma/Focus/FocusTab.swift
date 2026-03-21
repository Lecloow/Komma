//
//  FocusView.swift
//  Kómma
//
//  Created by Thomas Conchon on 12/22/25.
//

import SwiftUI

struct FocusView: View {
    var focusViewModel: FocusViewModel
    var projectViewModel: ProjectViewModel

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
            NavigationLink(destination: ChooseTaskView(viewModel: focusViewModel, project: project)) {
                Text(project.title)
            }
        }
    }
}

struct ChooseTaskView: View {
    var viewModel: FocusViewModel
    let project: Project
    
    var body: some View {
        VStack {
            Text("Now select a task to focus on and choose your work duration")
            CustomPickerView(viewModel: viewModel)
            tasks
        }
    }
    
    var tasks: some View {
        ForEach(project.tasks) { task in //TODO: Sort by progress and by due date
            NavigationLink(destination: SelectSubtasksView(viewModel: viewModel, task: task)) {
                Text(task.title)
            }
        }
    }
}

//TODO: better if you choose the time and an ai choose the subtasks for you

struct SelectSubtasksView: View {
    var viewModel: FocusViewModel
    let task: ProjectTask
    
    var body: some View {
        Text("You need to select all the subtasks you want to work on")
        Text("Recommended subtasks for you:").font(.caption)
        recommendedSubtasks //TODO: 
        //subtasks //Ai will choose for you based on the duration
        button
    }
    
    var recommendedSubtasks: some View {
        List {
            ForEach(task.subtasks.filter { !$0.isComplete }) { subtask in //Only not finished subtasks
                HStack {
                    Text(subtask.title)
                    Spacer()
                    selectButton(subtask: subtask)
                }
            }
        }
        .listStyle(.plain)
        .scrollContentBackground(.hidden)
    }
    var subtasks: some View {
        List {
            ForEach(task.subtasks.filter { !$0.isComplete }) { subtask in //Only not finished subtasks
                HStack {
                    Text(subtask.title)
                    Spacer()
                    selectButton(subtask: subtask)
                }
            }
        }
        .listStyle(.plain)
        .scrollContentBackground(.hidden)
    }
    func selectButton(subtask: Subtask) -> some View {
        let checkmark: some View = Image(systemName: viewModel.selectedSubtasks.contains(where: { $0.id == subtask.id }) ? "checkmark.circle.fill" : "circle").tint(.primary)
        
        return Button(action: { viewModel.select(subtask) }) {
            if #available(iOS 17.0, *) {
                checkmark
                    .contentTransition(.symbolEffect(.replace))
                    .tint(.primary)
            } else {
                checkmark
            }
        }
    }
    
    var button: some View {
        if #available(iOS 26.0, *) {
            AnyView( // No choice due to buttonSizing only available in iOS 26
            buttonContent
                .buttonSizing(.flexible)
                .buttonStyle(.glassProminent)
                .padding()
            )
        } else {
            AnyView(
            buttonContent
                .buttonStyle(.borderedProminent)
                .padding()
            )
        }
    }
    var buttonContent: some View {
        NavigationLink(destination: SetupSessionView(viewModel: viewModel)) {
            Text("Finish Setup")
                .frame(height: 35)
        }
        .tint(.primary)
    }
}

struct SetupSessionView: View {
    @Bindable var viewModel: FocusViewModel

    var body: some View {
        VStack(alignment: .leading) {
            Text("Before you start, please set your estimated focus duration and some notes about what are you doing")
            CustomPickerView(viewModel: viewModel)
            TextEditor(text: $viewModel.notes)
            Spacer()
            button
        }
        .padding()
    }
    
    var button: some View {
        if #available(iOS 26.0, *) {
            AnyView(
            buttonContent
                .buttonSizing(.flexible)
                .buttonStyle(.glassProminent)
                .padding()
            )
        } else {
            AnyView(
            buttonContent
                .buttonStyle(.borderedProminent)
                .padding()
            )
        }
    }
    var buttonContent: some View {
        NavigationLink(destination: TimerView(viewModel: viewModel)) {
            Text("Start Focusing!")
                .frame(height: 35)
        }
        .tint(.primary)
    }
}

#Preview {
    FocusView(focusViewModel: FocusViewModel(), projectViewModel: ProjectViewModel())
}
