//
//  FocusModel.swift
//  SSC 26
//
//  Created by Thomas Conchon on 12/22/25.
//

import Foundation

class FocusViewModel: ObservableObject {
    @Published private var model = createFocusModel()
    
    private static func createFocusModel() -> FocusModel {
        FocusModel()
    }
}
