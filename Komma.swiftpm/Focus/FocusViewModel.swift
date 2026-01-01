//
//  FocusModel.swift
//  Kómma
//
//  Created by Thomas Conchon on 12/22/25.
//

import Foundation

@MainActor
class FocusViewModel: ObservableObject {
    @Published private var model = createFocusModel()
    
    private static func createFocusModel() -> FocusModel {
        FocusModel()
    }
    
    var sessions: [Session] {
        model.sessions
    }
    var session: Session {
        model.session
    }
    
//    func startSession() {
//        model.startTimer()
//    }
//    
//    func stopSession() {
//        model.stopTimer()
//    }
    
    private var timer: Timer?
            
    // MARK: - User Intent(s)
    func startSession() {
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
