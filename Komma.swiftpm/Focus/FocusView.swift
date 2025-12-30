//
//  FocusView.swift
//  SSC 26
//
//  Created by Thomas Conchon on 12/22/25.
//

import SwiftUI

struct FocusView: View {
    @ObservedObject var viewModel: FocusViewModel //TODO: New Model ??? or use the project
    
    var body: some View {
        Text("Focus View")
        Button(action: { viewModel.startSession() }) {
            Text("Start timer")
        }
        Text(formatTime(viewModel.session.elapsedTime))
            .font(.system(size: 40, weight: .bold))
        Button(action: { viewModel.stopSession() }) {
            Text("Stop")
        }
        Button(action: { viewModel.resetTimer() }) {
            Text("Reset")
        }
    }
    
    
    func formatTime(_ seconds: Int) -> String {
        let minutes = seconds / 60
        let secs = seconds % 60
        return String(format: "%02d:%02d", minutes, secs)
    }
}
