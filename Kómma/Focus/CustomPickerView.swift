//
//  CustomPickerView.swift
//  Kómma
//
//  Created by Thomas Conchon on 1/15/26.
//

import SwiftUI

struct CustomPickerView: View { // Why this is not a basic SwiftUI component, it may be so useful
    @Bindable var viewModel: FocusViewModel
    let spaceBetweenPicker: CGFloat = -22
    let offset: CGFloat = -10 // Don't ask why, it just works
    
    var body: some View {
        VStack {
            HStack(spacing: 0) {
                Picker(selection: $viewModel.estimatedHours, label: Text("Picker")) {
                    ForEach(0..<24) { hour in
                        Text("\(hour)").tag(hour)
                    }
                }
                .pickerStyle(.wheel)
                .clipShape(.rect.offset(x: spaceBetweenPicker))
                .padding(.trailing, spaceBetweenPicker)
                Color(hex: "f4f4f5")
                    .overlay(Text(viewModel.estimatedHours > 1 ? "Hours" : "Hour")
                        .font(.headline), alignment: .leading)
                    .offset(x: offset)
                    .frame(width: 80, height: 32)
                Color(hex: "f4f4f5")
                    .frame(width: 50, height: 32)
                    .offset(x: offset)
                Picker(selection: $viewModel.estimatedMinutes, label: Text("Picker")) {
                    ForEach(0..<60) { minute in
                        Text("\(minute)").tag(minute)
                    }
                }
                .pickerStyle(.wheel)
                .clipShape(.rect.offset(x: -spaceBetweenPicker))
                .clipShape(.rect.offset(x: spaceBetweenPicker))
                .padding(.leading, spaceBetweenPicker+offset)
                RoundedCornerShape(radius: 40, corners: [.topRight, .bottomRight])
                    .foregroundStyle(Color(hex: "f4f4f5"))
                    .overlay(
                        Text(viewModel.estimatedMinutes > 1 ? "Mins" : "Min")
                        .font(.headline),
                        alignment: .leading)
                    .offset(x: 3*offset)
                    .frame(width: 70, height: 32)
            }
            .padding()
        }
        .font(.title)
    }
}
