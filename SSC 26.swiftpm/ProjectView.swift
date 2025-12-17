//
//  ProjectView.swift
//  SSC 26
//
//  Created by Thomas Conchon on 12/8/25.
//

import SwiftUI

struct ProjectView: View {
    var project: ProjectManager.Project
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(project.title)
                .font(.largeTitle)
            Divider()
            Text(project.description)
            Text(project.deadline, format: .dateTime)
            //Text(project.deadline)
            //Text(project.status)
            switch project.status {
            case .later:
                Text("later").foregroundStyle(.gray)
            case .onHold:
                Text("on Hold").foregroundStyle(.red)
            case .inProgress:
                Text("in Progress").foregroundStyle(.blue)
            case .inReview:
                Text("In Review").foregroundStyle(.orange)
            case .done:
                Text("Done").foregroundStyle(.green)
            }
            //TODO: The Text is not supposed to be in Color but the back is. Color inspired from Notion (pastel)
            Text("Progress: \(project.progress)")
            Text("id: \(project.id)")
            Spacer()
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                }) {
                    Image(systemName: "square.and.pencil")
                }
            }
        } //TODO: Button Delete etc...
        .multilineTextAlignment(.leading)
        .padding()
    }
}
