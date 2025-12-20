//
//  CreateProjectView.swift
//  SSC 26
//
//  Created by Thomas Conchon on 12/16/25.
//

import SwiftUI
//
//struct CreateProjectView: View {
//    @ObservedObject var viewModel: ProjectViewModel
//    @Environment(\.dismiss) private var dismiss
//    @State var project: Project?
//        
//    var body: some View {
//        VStack {
//            if project != nil {
//                VStack(alignment: .leading) {
//                    TextField("Untitled", text: Binding(
//                        get: { project!.title },
//                        set: { newValue in
//                            project!.title = newValue
//                            updateProject()
//                        }
//                    ))
//                        .font(.largeTitle)
//                    Divider()
//                    TextField("Description", text: Binding(
//                        get: { project!.description},
//                        set: { newValue in
//                            project!.description = newValue
//                            updateProject()
//                        }
//                    ))
////                    Text(project!.deadline, format: .dateTime)
//                    DatePicker(
//                            "Deadline",
//                            selection: Binding(
//                                get: { project!.deadline },
//                                set: { newValue in
//                                    project!.deadline = newValue
//                                    updateProject()
//                                }
//                            ),
//                            displayedComponents: [.date]
//                        )
//                    //FIXME: It's supposed to be at the left not at the right
//
//                    if let status = project?.status {
//                        Picker("Change Status", selection: Binding(
//                            get: { status },
//                            set: { newValue in
//                                project?.status = newValue
//                                updateProject()
//                            }
//                        )) {
//                            Text("Later").tag(Status.later)
//                            Text("On Hold").tag(Status.onHold)
//                            Text("In Progress").tag(Status.inProgress)
//                            Text("In Review").tag(Status.inReview)
//                            Text("Done").tag(Status.done)
//                        }
//                    }
//                    // TODO: The Text is not supposed to be in Color but the back is. Color inspired from Notion (pastel)
////                    Text("Progress: \(project.progress)")
//                        ForEach(project!.subTasks) { subTask in
//                            Text(subTask.title)
//                            Button(action: {
//                                viewModel.completeSubTask(project: project!, subTask: subTask)
//                                print(subTask)
//                            }) {
//                                if #available(iOS 17.0, *) {
//                                    Image(systemName: subTask.isComplete ? "checkmark.circle" : "circle")
//                                        .contentTransition(.symbolEffect(.replace))
//                                } else {
//                                    Image(systemName: subTask.isComplete ? "checkmark.circle" : "circle")
//                                }
//                            }
//                        }
//                    Button(action: {
//                        let subTask: SubTask = .init(id: 0, title: "Random Subtask", isComplete: false)
//                        viewModel.addSubTask(project: project!, subTask: subTask)
//                        print(subTask)
//                        print(project!)
//                    }) {
//                        Text("Add subtask")
//                    }
//                    Spacer()
//                }
//                .toolbar { toolbar }
//                .multilineTextAlignment(.leading)
//                .padding()
//            }
//        }
//        .onAppear {
//            if project == nil {
//                viewModel.addProject(title: "", description: "", deadline: Date())
//                project = viewModel.projects.last!
//            }
//        }
//    }
//    
//    var toolbar: some ToolbarContent {
//        ToolbarItem(placement: .navigationBarTrailing) {
//            if #available(iOS 26.0, *) {
//                Button(action: { dismiss() }) {
//                    Image(systemName: "checkmark")
//                }
//                .buttonStyle(.glassProminent)
//                .tint(.primary)
//            } else {
//                Button(action: { dismiss() }) {
//                    Image(systemName: "checkmark")
//                }
//                .buttonStyle(.borderedProminent)
//                .tint(.primary)
//            }
//        }
//    }
//    
//    private func updateProject() {
//        if project != nil {
//            viewModel.update(project: project!)
//        }
//    }
//}

//FIXME: Clean this code

struct CreateProjectView: View {
    @ObservedObject var viewModel: ProjectViewModel
    @Environment(\.dismiss) private var dismiss
    
    @State var projectId: Int?
        
    private var project: Project? {
        guard let id = projectId else { return nil }
        return viewModel.projects.first(where: { $0.id == id })
    }
        
    var body: some View {
        VStack {
            if let project = project {  // ← if LET, pas if VAR
                VStack(alignment: .leading) {
                    TextField("Untitled", text: Binding(
                        get: { project.title },
                        set: { newValue in
                            var updatedProject = project  // ← Copie locale DANS le Binding
                            updatedProject.title = newValue
                            viewModel.update(project: updatedProject)  // ← Update direct
                        }
                    ))
                    .font(.largeTitle)
                    
                    Divider()
                    
                    TextField("Description", text: Binding(
                        get: { project.description },
                        set: { newValue in
                            var updatedProject = project
                            updatedProject.description = newValue
                            viewModel.update(project: updatedProject)
                        }
                    ))
                    
                    DatePicker(
                        "Deadline",
                        selection: Binding(
                            get: { project.deadline },
                            set: { newValue in
                                var updatedProject = project
                                updatedProject.deadline = newValue
                                viewModel.update(project: updatedProject)
                            }
                        ),
                        displayedComponents: [.date]
                    )

                    Picker("Change Status", selection: Binding(
                        get: { project.status },
                        set: { newValue in
                            var updatedProject = project
                            updatedProject.status = newValue
                            viewModel.update(project: updatedProject)
                        }
                    )) {
                        Text("Later").tag(Status.later)
                        Text("On Hold").tag(Status.onHold)
                        Text("In Progress").tag(Status.inProgress)
                        Text("In Review").tag(Status.inReview)
                        Text("Done").tag(Status.done)
                    }
                    
                    ForEach(project.subTasks) { subTask in
                        HStack {
                            Text(subTask.title)
                            Button(action: { viewModel.completeSubTask(project: project, subTask: subTask) }) { //FIXME: Not here but in the ProjectView and add haptic and confetti
                                if #available(iOS 17.0, *) {
                                    Image(systemName: subTask.isComplete ? "checkmark.circle.fill" : "circle")
                                        .contentTransition(.symbolEffect(.replace))
                                } else {
                                    Image(systemName: subTask.isComplete ? "checkmark.circle.fill" : "circle")
                                }
                            }
                        }
                    }
                    
                    Button(action: { viewModel.addSubTask(project: project, title: "Subtask") }) {
                        Text("Add subtask")
                    }
                    
                    Spacer()
                }
                .toolbar { toolbar }
                .multilineTextAlignment(.leading)
                .padding()
            }
        }
        .onAppear {
            if projectId == nil {
                viewModel.addProject(title: "", description: "", deadline: Date())
                projectId = viewModel.projects.last?.id
            }
        }
    }
    
    var toolbar: some ToolbarContent {
        ToolbarItem(placement: .navigationBarTrailing) {
            if #available(iOS 26.0, *) {
                Button(action: { dismiss() }) {
                    Image(systemName: "checkmark")
                }
                .buttonStyle(.glassProminent)
                .tint(.primary)
            } else {
                Button(action: { dismiss() }) {
                    Image(systemName: "checkmark")
                }
                .buttonStyle(.borderedProminent)
                .tint(.primary)
            }
        }
    }
}
