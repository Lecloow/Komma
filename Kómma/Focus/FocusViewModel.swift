//
//  FocusModel.swift
//  Kómma
//
//  Created by Thomas Conchon on 12/22/25.
//

import Foundation

@MainActor
@Observable class FocusViewModel {
    private var model = createFocusModel()
    
    private(set) var selectedSubtasks: [Subtask] = []
    var estimatedMinutes: Int = 25
    var estimatedHours: Int = 0
    var estimatedTime: TimeInterval {
        TimeInterval(estimatedMinutes*60+estimatedHours*3600) //FIXME: Perhaps
    }
    var notes: String = ""
    
    private static func createFocusModel() -> FocusModel {
        FocusModel()
    }
    
    var sessions: [Session] {
        model.sessions
    }
    var session: Session {
        model.session
    }
    
    private var timer: Timer?
            
    // MARK: - User Intent(s)
    
    func select(_ subtask: Subtask) {
        if selectedSubtasks.contains(where: { $0.id == subtask.id }) {
            selectedSubtasks.removeAll(where: { $0.id == subtask.id })
        } else {
            selectedSubtasks.append(subtask)
        }
    }
    
    func startSession() {
        model.createSession(selectedSubtasks)
    }
    
    func startTimer() {
        guard !session.isRunning else { return }
        
        model.startTimer()
        
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            Task { @MainActor [weak self] in
                self?.model.tick()
            }
        }
    }
    
    func stopSession() {
        timer?.invalidate()
        timer = nil
        model.stopTimer()
    }
    
    func resetTimer() {
        stopSession()
        model.reset()
    }
}
