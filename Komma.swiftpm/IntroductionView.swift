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
            RoundedCornerShape(radius: 50, corners: [.bottomLeft, .bottomRight])
                .foregroundStyle(.green)
                .ignoresSafeArea()
                .overlay(/*alignment: .leading*/ ) {
                    VStack(alignment: .leading) {
                        HStack {
                            Spacer()
                            Color.red.frame(width: 300, height: 300) // Animated Logo
                            Spacer()
                        }
                        Group {
                            Text("Logo & Kómma")
                                .font(.title)
                                .padding(.top)
                            Text("The app to help you focus on work")
                                .font(.largeTitle)
                            Text("Description: blakaldbk bdjqdjb ss dvjdjqkddid sgdksdgdshs ddssgdisdifndjfb dhfdihf")
                                .font(.title3)
                        }
                        .padding(.vertical, 1)
                        .padding(.horizontal)
                    }
                    .padding()
                }
            buttonView
                .padding()
        }
    }
    
    var buttonView: some View {
        if #available(iOS 26.0, *) {
            AnyView(
            button
                .buttonSizing(.flexible)
                .buttonStyle(.glassProminent)
            )
        } else {
            AnyView(
            button
                .buttonStyle(.borderedProminent)
            )
        }
    }
    var button: some View {
        Button(action: { isFirstUse = false }) {
            Text("Let's get started")
                .font(.title2)
                .frame(height: 35)
        }
        .tint(.primary)
    }
}
// MARK: - Supporting Rounded Corner Shape

struct RoundedCornerShape: Shape {
    var radius: CGFloat = .infinity
    var corners: RectCorner = .allCorners
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect,
                                byRoundingCorners: corners.uiRectCorner,
                                cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

struct RectCorner: OptionSet {
    let rawValue: Int
    
    static let topLeft = RectCorner(rawValue: 1 << 0)
    static let topRight = RectCorner(rawValue: 1 << 1)
    static let bottomLeft = RectCorner(rawValue: 1 << 2)
    static let bottomRight = RectCorner(rawValue: 1 << 3)
    static let allCorners: RectCorner = [.topLeft, .topRight, .bottomLeft, .bottomRight]

    var uiRectCorner: UIRectCorner {
        var rectCorner: UIRectCorner = []
        if contains(.topLeft) { rectCorner.insert(.topLeft) }
        if contains(.topRight) { rectCorner.insert(.topRight) }
        if contains(.bottomLeft) { rectCorner.insert(.bottomLeft) }
        if contains(.bottomRight) { rectCorner.insert(.bottomRight) }
        return rectCorner
    }
}

