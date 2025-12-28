//
//  ProjectView.swift
//  SSC 26
//
//  Created by Thomas Conchon on 12/8/25.
//

import SwiftUI
import ConfettiSwiftUI


struct ProjectView: View {
    @ObservedObject var viewModel: ProjectViewModel
    var project: Project
    @Environment(\.dismiss) private var dismiss
    
    @State var isShowingDeletePopup = false

    var body: some View {
        VStack(alignment: .leading) {
            Text(project.title)
                .font(.largeTitle)
            Divider()
            ProjectInformation(project: project)
            Divider()
            subtasks
            Spacer()
        }
        .confettiCannon(trigger: $viewModel.confettiCounter)
        .alert("Delete Project ?", isPresented: $isShowingDeletePopup) {
            alertContent
        } message: {
            Text("This will permanently delete the project. You can't undo this.")
        }
        .toolbar {
            toolbar
        }
        .multilineTextAlignment(.leading)
        .padding()
    }
    
    var subtasks: some View {
        List {
            ForEach(project.subtasks) { subTask in
                SubtaskView(viewModel: viewModel, subtask: subTask)
                    .listRowInsets(EdgeInsets())
            }
        }
        .listStyle(. plain)
        .scrollContentBackground(.hidden)
    }
    
    var alertContent: some View {
        HStack {
            Button("Cancel", role: .cancel) { }
            Button("Delete Project", role: .destructive) {
                viewModel.delete(project: project)
                dismiss()
            }
        }
    }
    
    var toolbar: some ToolbarContent {
        ToolbarItem(placement: .navigationBarTrailing) {
            HStack {
                NavigationLink(destination: CreateProjectView(viewModel: viewModel, projectId: project.id)) {
                    Image(systemName: "square.and.pencil")
                }
                Menu {
                    NavigationLink(destination: CreateProjectView(viewModel: viewModel, projectId: project.id)) {
                        Label("Edit Project", systemImage: "square.and.pencil")
                    }
                    Button(action: { }) { //TODO: Star or pin project
                        Label("Add to favorites", systemImage: "plus")
                    }
                    Divider()
                    Button(role: .destructive, action: { isShowingDeletePopup = true }) {
                        Label("Delete Project", systemImage: "trash")
                    }
                } label: {
                    Image(systemName: "ellipsis")
                }
            }
        }
    }
}

struct ProjectInformation: View {
    var project: Project
    
    var body: some View {
        Text(project.description)
        Text("\(project.deadline.formatted(date: .abbreviated, time: .omitted))")
        status
        priority
        Text("Progress: \(project.progress)%")
        ProgressView(value: Double(project.progress)/100)
            .tint(.primary)
            .animation(.easeInOut, value: project.progress)
    }
    
    var status: some View {
        HStack {
            Text("Status: ")
            switch project.status {
            case .later:
                badge("Later", color: .pink)
            case .onHold:
                badge("On hold", color: .red)
            case .inProgress:
                badge("In progress", color: .blue)
            case .inReview:
                badge("In review", color: .purple)
            case .done:
                badge("Done", color: .green)
            }
        }
    }
    
    var priority: some View {
        HStack {
            Text("Priority: ")
            switch project.priority {
            case .low:
                badge("Low", color: .blue)
            case .normal:
                badge("Normal", color: .green)
            case .high:
                badge("High", color: .orange)
            case .urgent:
                badge("Urgent", color: .red)
            }
        }
    }
    //FIXME: Ui is fade need waouh effect
    func badge(_ content: String, color: CustomColor) -> some View {
        BadgeView(content: content, color: color)
    }
}
