//
//  ProjectView.swift
//  SSC 26
//
//  Created by Thomas Conchon on 12/8/25.
//

import SwiftUI

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
        .alert("Delete Project ?", isPresented: $isShowingDeletePopup) {
            Button("Cancel", role: .cancel) { }
            Button("Delete Project", role: .destructive) {
                viewModel.delete(project: project)
                dismiss()
            }
        } message: {
            Text("This will permanently delete the project. You can't undo this.")
        }
        .toolbar {
            toolbar
        } //TODO: Button Delete etc...
        .multilineTextAlignment(.leading)
        .padding()
    }
    
    var subtasks: some View {
        List {
            ForEach(project.subTasks) { subTask in
                SubTaskView(viewModel: viewModel, projectId:  project.id, subTaskId: subTask.id)
                    //.listRowBackground(Color.clear)
                    .listRowInsets(EdgeInsets())
            }
        }
        .listStyle(. plain)
        .scrollContentBackground(.hidden)
    }
    
    var toolbar: some ToolbarContent {
        ToolbarItem(placement: .navigationBarTrailing) {
            HStack {
                NavigationLink(destination: CreateProjectView(viewModel: viewModel, projectId: project.id)) {
                    Image(systemName: "square.and.pencil")
                }
                Menu {
                    Button(role: .destructive, action: { isShowingDeletePopup = true }) {
                        Label("Delete Project", systemImage: "trash")
                    }
                    Button(action: { }) {
                        Label("IDK", systemImage: "mappin")
                    }
                } label: {
                    Image(systemName: "gear")
                }
            }
        }
    }
}
//FIXME: Clean this shit

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
    
    var priority: some View {
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
    
    func badge(_ content: String, color: CustomColor) -> some View {
        BadgeView(content: content, color: color)
    }
}
