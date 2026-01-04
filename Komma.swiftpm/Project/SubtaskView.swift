//
//  SubtaskView.swift
//  Kómma
//
//  Created by Thomas Conchon on 12/20/25.
//

import SwiftUI

struct SubtaskView: View {
    var mode: Mode = .view
    @ObservedObject var viewModel:  ProjectViewModel
    let subtask:  Subtask
    @State var isShowingPopup = false
    @State var isShowingEditPopup = false
    @State private var hasAppeared = false

    var body: some View {
        VStack {
            switch mode {
            case .edit:
                Button(action: { isShowingEditPopup = true }) {
                    Text(subtask.title)
                        .padding(.leading)
                }
                .transformToSubtaskView(viewModel: viewModel, subtask: subtask)
                .onAppear {
                    if !hasAppeared && subtask.title.isEmpty {
                        isShowingEditPopup = true
                        hasAppeared = true
                    }
                }
            case .view:
                Button(action: { isShowingPopup = true }) {
                    Text(subtask.title)
                }
                .transformToSubtaskView(viewModel:  viewModel, subtask: subtask)
                .swipeActions(edge: .trailing) {
                    Button {
                        viewModel.completeSubtask(subtask)
                    } label: {
                        Label(subtask.isComplete ? "Undo" : "Done", systemImage: subtask.isComplete ?  "xmark" : "checkmark")
                    }
                    .tint(subtask.isComplete ? .gray : .green)
                }
            }
        }
        .sheet(isPresented: $isShowingPopup) {
            SubtaskEditSheet(viewModel:  viewModel, subtask: subtask)
        }
        .sheet(isPresented: $isShowingEditPopup) {
            SubtaskEditSheet(mode: .edit, viewModel:  viewModel, subtask: subtask)
        }
    }
}

struct SubtaskEditSheet: View {
    var mode: Mode = .view
    @ObservedObject var viewModel: ProjectViewModel
    var subtask: Subtask
    @Environment(\.dismiss) var dismiss
    @FocusState private var isFocused: Bool
    
    @State private var notes: String
    
    init(mode: Mode = .view, viewModel: ProjectViewModel, subtask: Subtask) {
        self.viewModel = viewModel
        self.subtask = subtask
        self.mode = mode
        _notes = State(initialValue: subtask.notes)
    } //Really difficult just to make the sure the textEditor is not rebuild after by the binding
    
    
    var body:  some View {
        NavigationView {
            VStack(alignment:  .leading) {
                switch mode { //FIXME: Simplify
                case .view:
                    Text(subtask.title)
                        .font(.title)
                case .edit:
                    TextField("Untitled Subtask", text: viewModel.bindingSubtask(for: subtask, keyPath: \.title))
                        .focused($isFocused)
                        .font(.title)
                }
                Divider()
                Text("Notes:")
                    .font(.headline)
                    .padding(.vertical, 10)
                
                switch mode {
                case .view:
                    Text(subtask.notes)
                case .edit:
                    ZStack(alignment: .topLeading) { //FIXME: alignment bug
                        if subtask.notes.isEmpty {
                            Text("Enter subtask details...") //FIXME: change text
                                .foregroundColor(.gray.opacity(0.5))
                                .allowsHitTesting(false)
                        }
                        TextEditor(text: $notes)
                            .frame(minHeight: 200)
                            .background(.clear)
                            .scrollContentBackground(.hidden)
                            .onChange(of: notes) { newValue in
                                viewModel.updateNotes(for: subtask, notes: newValue)
                            }
                    }
                }
                Spacer()
            }
            .padding()
            .padding(.top)
            .onAppear { isFocused = true }
        }
        .presentationDetents([.medium, .large])
    }
}

enum Mode {
    case edit, view
}

struct TransformToSubtaskView: ViewModifier {
    @ObservedObject var viewModel: ProjectViewModel
    let subtask: Subtask
    
    func body(content: Content) -> some View {
        HStack {
            content
            Spacer()
            Button(action: { viewModel.completeSubtask(subtask) }) {
                if #available(iOS 17.0, *) {
                    Image(systemName: subtask.isComplete ? "checkmark.circle.fill" : "circle")
                        .contentTransition(.symbolEffect(.replace))
                        .tint(.primary)
                        .sensoryFeedback(subtask.isComplete ? .stop : .success, trigger: subtask.isComplete)
                } else {
                    Image(systemName: subtask.isComplete ? "checkmark.circle.fill" : "circle")
                        .tint(.primary)
                }
            }
            .buttonStyle(.plain)
            .padding(.horizontal)
        }
    }
}

extension View {
    func transformToSubtaskView(viewModel: ProjectViewModel, subtask: Subtask) -> some View {
        modifier(TransformToSubtaskView(viewModel: viewModel, subtask: subtask))
    }
}
