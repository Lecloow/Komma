//
//  CardView.swift
//  SSC 26
//
//  Created by Thomas Conchon on 12/8/25.
//

import SwiftUI

struct CardView: View {
    
    let project: Project
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 12)
                .fill(.white)
                .aspectRatio(32/9, contentMode: .fit)
            RoundedRectangle(cornerRadius: 12)
                .stroke(.gray)
                .aspectRatio(32/9, contentMode: .fit)
            HStack {
                VStack(alignment: .leading) {
                    Text(project.title)
                        .font(.title)
                    Text("Deadline: \(project.deadline.formatted(date: .abbreviated, time: .omitted))")
                    Text(project.description)
                        .font(.caption)
                }
                Spacer()
                VStack {
                    Text("\(project.progress)")
                    Image(systemName: "progress.indicator")
                }
            }
            .foregroundStyle(.primary)
            .padding()
        }
        .padding(.horizontal)
    }
}
//TODO: Darkmode
