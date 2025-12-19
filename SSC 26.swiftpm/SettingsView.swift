//
//  SettingsView.swift
//  SSC 26
//
//  Created by Thomas Conchon on 12/8/25.
//

import SwiftUI

struct SettingsView: View {
    @ObservedObject var viewModel: ProjectViewModel
    @State var showImporter = false
    @State var isShowingResetPopup = false
    
    var body: some View {
        VStack {
            List {
                Button("Export Projects") {
                    if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                       let root = scene.windows.first?.rootViewController {
                        viewModel.exportProjects(viewModel.projects, from: root)
                    }
                }
                Button("Import Projects") {
                    showImporter = true
                }
                Button("Delete All Projects") {
                    isShowingResetPopup = true
                }
                .foregroundStyle(.red)
            }
        }
        .alert("Delete All Projects ?", isPresented: $isShowingResetPopup) {
            Button("Cancel", role: .cancel) { }
            Button("Delete Everything", role: .destructive) {
                viewModel.deleteAccount()
                viewModel.loadProjects()
            }
        } message: {
            Text("This will permanently delete all your projects. You can't undo this.")
        }
        .foregroundStyle(.primary)
        .sheet(isPresented: $showImporter) {
            ImportJSONView { url in
                viewModel.importProjects(from: url)
                viewModel.loadProjects()
            }
        }
    }
}
