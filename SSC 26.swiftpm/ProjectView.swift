//
//  ProjectView.swift
//  SSC 26
//
//  Created by Thomas Conchon on 12/8/25.
//

import SwiftUI

struct ProjectView: View {
    var project: ProjectModel.Project
    
    var body: some View {
        Text("id \(project.id)")
    }
}
