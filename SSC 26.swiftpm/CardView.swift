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
                    CircularProgressView(progress: CGFloat(project.progress) / 100)
                        .frame(width: 20, height: 20)
                }
            }
            .foregroundStyle(.primary)
            .padding()
        }
        .padding(.horizontal)
    }
}
//TODO: Darkmode

struct CircularProgressView: View {
    let progress: CGFloat
    let lineWidth: CGFloat = 3.5
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(lineWidth: lineWidth)
                .opacity(0.1)
                .foregroundColor(.primary)
            
            Circle()
                .trim(from: 0.0, to: min(progress, 1.0))
                .stroke(style: StrokeStyle(lineWidth: lineWidth, lineCap: .round, lineJoin: .round))
                .foregroundColor(.primary)
                .rotationEffect(Angle(degrees: 270.0))
                .animation(.easeInOut, value: progress)
        }
    }
}
