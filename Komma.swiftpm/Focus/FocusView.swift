//
//  FocusView.swift
//  Kómma
//
//  Created by Thomas Conchon on 12/22/25.
//

import SwiftUI

struct FocusView: View {
    @ObservedObject var focusViewModel: FocusViewModel
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
            NavigationLink(destination: ChooseTaskView(viewModel: focusViewModel, project: project)) {
                Text(project.title)
            }
        }
    }
}

struct ChooseTaskView: View {
    @ObservedObject var viewModel: FocusViewModel
    let project: Project
    
    var body: some View {
        VStack {
            Text("Now select a task to focus on!")
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

struct SelectSubtasksView: View {
    @ObservedObject var viewModel: FocusViewModel
    let task: ProjectTask
    
    var body: some View {
        Text("You need to select all the subtasks you want to work on")
        subtasks
        button
    }
    
    var subtasks: some View {
        List {
            ForEach(task.subtasks) { subtask in
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
        }
        .tint(.primary)
    }
}

struct SetupSessionView: View {
    @ObservedObject var viewModel: FocusViewModel

    var body: some View {
        VStack(alignment: .leading) {
            Text("Before you start, please set your estimated focus duration and some notes about what are you doing")
            HStack {
                Spacer()
                CustomPickerView(viewModel: viewModel)
                Spacer()
            }
            Spacer()
            button
        }
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
        }
        .tint(.primary)
    }
}

struct CustomPickerView: View { // Why this is not a basic SwiftUI component, it may be so useful
    @ObservedObject var viewModel: FocusViewModel
    let spaceBetweenPicker: CGFloat = -22
    let offset: CGFloat = -20 // Don't ask why, it just works
    
    var body: some View {
        VStack {
            HStack(spacing: 0) {
                Picker(selection: $viewModel.estimatedHours, label: Text("Picker")) {
                    ForEach(0..<24) { hour in
                        Text("\(hour)").tag(hour)
                    }
                }
                .pickerStyle(.wheel)
                .clipShape(.rect.offset(x: spaceBetweenPicker))
                .padding(.trailing, spaceBetweenPicker)
                Color(hex: "f4f4f5")
                    .overlay(Text(viewModel.estimatedHours > 1 ? "Hours" : "Hour")
                        .font(.headline), alignment: .leading)
                    .offset(x: offset)
                    .frame(width: 80, height: 32)
                Color(hex: "f4f4f5")
                    .frame(width: 50, height: 32)
                    .offset(x: offset)
                Picker(selection: $viewModel.estimatedMinutes, label: Text("Picker")) {
                    ForEach(0..<60) { minute in
                        Text("\(minute)").tag(minute)
                    }
                }
                .pickerStyle(.wheel)
                .clipShape(.rect.offset(x: -spaceBetweenPicker))
                .clipShape(.rect.offset(x: spaceBetweenPicker))
                .padding(.leading, spaceBetweenPicker+offset)
                RoundedRectangle(cornerRadius: 40).foregroundStyle(Color(hex: "f4f4f5"))
                    .overlay(Text(viewModel.estimatedMinutes > 1 ? "Mins" : "Min")
                        .font(.headline), alignment: .leading)
                    .offset(x: 2*offset)
                    .frame(width: 80, height: 32)
            }
            .padding()
        }
        .font(.title)
    }
}

struct TimerView: View { // Finally the real focus view
    @ObservedObject var viewModel: FocusViewModel
    
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
