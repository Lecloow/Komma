//
//  SplashScreen.swift
//  Kómma
//
//  Created by Thomas Conchon on 3/13/26.
//

import SwiftUI

struct SplashScreenView: View {
    var body: some View {
        ZStack {
            Color.init(hex: "0094FF")
                .ignoresSafeArea()
            
            VStack {
//                Image(systemName: "bus.fill")
//                    .resizable()
//                    .frame(width: 100, height: 100)
//                    .foregroundColor(.blue)
                Spacer()
                
                Text("Kómma")
                    .foregroundStyle(.white)
                    .font(.system(size: 36, weight: .bold, design: .default))
                    .bold()
                    .padding(.top, 16)
                Spacer()
                Spacer()
                Text("by Thomas Conchon")
                    .foregroundStyle(.white)
                    .font(.system(size: 20, weight: .bold, design: .default))
                    .bold()
                    .padding(.top, 16)
            }
        }
    }
}

#Preview {
    SplashScreenView()
}
