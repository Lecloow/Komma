//
//  IntroductionView.swift
//  Kómma
//
//  Created by Thomas Conchon on 12/29/25.
//

import SwiftUI

struct IntroductionView: View {
    @AppStorage("isFirstUse") var isFirstUse: Bool = true
    
    var body: some View {
        VStack {
            RoundedCornerShape(radius: 50, corners: [.bottomLeft, .bottomRight])
                .foregroundStyle(Color(hex:"#0060d6")) //a beautiful blue (#0060d6), or a green (#2e9f84)
                .ignoresSafeArea()
                .overlay(/*alignment: .leading*/ ) {
                    VStack(alignment: .leading) {
                        HStack {
                            Spacer()
                            Color.red.frame(width: 300, height: 300) //TODO: Animated Logo
                            Spacer()
                        }
                        Group {
                            HStack {
                                //Image("logo") //TODO: Little logo
                                Text("Kómma")
                            }
                                .font(.system(.title, design: .rounded))
                                .fontWeight(.semibold)
                                .padding(.top)
                            Text("The app to help you focus on work")
                                .font(.system(.largeTitle, design: .rounded))
                                .fontWeight(.semibold)
                            Text("ad ullamco amet sit reprehenderit ipsum veniam excepteur do eu sunt occaecat officia aute labore")//TODO: description
                                .font(.title3)
                        }
                        .foregroundStyle(.white)
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
        //NavigationLink(destination: IntroductionCarrousel()) {
        Button(action: { isFirstUse = false }) { //TODO: IntroductionCarrousel
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
