//
//  CreateProjectView.swift
//  SSC 26
//
//  Created by Thomas Conchon on 12/16/25.
//

import SwiftUI

struct CreateProjectView: View {
    @ObservedObject var viewModel: ProjectViewModel
    @State var project: ProjectManager.Project?
        
    var body: some View {
        VStack {
            if project != nil {
                VStack(alignment: .leading) {
                    TextField("Untitled", text: Binding(
                        get: { project!.title },
                        set: { newValue in
                            project!.title = newValue
                            updateProject()
                        }
                    ))
                        .font(.largeTitle)
                    Divider()
                    TextField("Description", text: Binding(
                        get: { project?.description ?? "" },
                        set: { newValue in
                            project?.description = newValue
                            updateProject()
                        }
                    ))
//                    Text(project!.deadline, format: .dateTime)
                    DatePicker(
                            "Deadline",
                            selection: Binding(
                                get: { project!.deadline },
                                set: { newValue in
                                    project!.deadline = newValue
                                    updateProject()
                                }
                            ),
                            displayedComponents: [.date]
                        )
                    //FIXME: It's supposed to be at the left not at the right
                    if let status = project?.status {
                        Picker("Change Status", selection: Binding(
                            get: { status },
                            set: { newValue in
                                project?.status = newValue
                                updateProject()
                            }
                        )) {
                            Text("Later").tag(ProjectManager.Status.later)
                            Text("On Hold").tag(ProjectManager.Status.onHold)
                            Text("In Progress").tag(ProjectManager.Status.inProgress)
                            Text("In Review").tag(ProjectManager.Status.inReview)
                            Text("Done").tag(ProjectManager.Status.done)
                        }
                    }
//                    switch project.status {
//                    case .later:
//                        Text("later").foregroundStyle(.gray)
//                    case .onHold:
//                        Text("on Hold").foregroundStyle(.red)
//                    case .inProgress:
//                        Text("in Progress").foregroundStyle(.blue)
//                    case .inReview:
//                        Text("In Review").foregroundStyle(.orange)
//                    case .done:
//                        Text("Done").foregroundStyle(.green)
//                    }
                    // TODO: The Text is not supposed to be in Color but the back is. Color inspired from Notion (pastel)
//                    Text("Progress: \(project.progress)")
                    Spacer()
                }
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: {
                        }) {
                            Image(systemName: "square.and.pencil")
                        }
                    }
                } // TODO: Button Delete etc...
                .multilineTextAlignment(.leading)
                .padding()
            }
        }
        .onAppear {
            if project == nil {
                viewModel.addProject(title: "", description: "", deadline: Date())
                project = viewModel.projects.last!
            }
        }
    }
    
    private func updateProject() {
        if project != nil {
            viewModel.update(project: project!)
        }
    }
}
