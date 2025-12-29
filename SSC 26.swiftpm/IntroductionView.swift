//
//  IntroductionView.swift
//  SSC 26
//
//  Created by Thomas Conchon on 12/29/25.
//

import SwiftUI

struct IntroductionView: View {
    @AppStorage("isFirstUse") var isFirstUse: Bool = true
    
    var body: some View {
        VStack {
            Text("Introduction View")
            if #available(iOS 26.0, *) {
                button
                    .buttonStyle(.glassProminent)
                    .buttonSizing(.flexible)
            } else {
                button.buttonStyle(.borderedProminent)
            }
        }
        .padding()
    }
    
    var button: some View {
        Button(action: { isFirstUse = false }) {
            Text("Finish")
        }
        .tint(.primary)
    }
}
