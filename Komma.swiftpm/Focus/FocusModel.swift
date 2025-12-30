//
//  FocsuModel.swift
//  Kómma
//
//  Created by Thomas Conchon on 12/22/25.
//

import Foundation

struct FocusModel {
    private(set) var session: Session
    
    init() {
        session = Session(subtasks: [])
    }
    
    mutating func startTimer() {
        session.isRunning = true
    }
    
    mutating func stopTimer() {
        session.isRunning = false
    }
    
    mutating func tick() {
        session.elapsedTime += 1
    }
    
    mutating func reset() {
        session.elapsedTime = 0
        session.isRunning = false
    }
}


struct Session {
    var subtasks: [Subtask]
    var isRunning = false
    var estimatedTime: Int = 0
    var timer: Timer?
    var elapsedTime: Int = 0
}
