//
//  SettingsView.swift
//  Kómma
//
//  Created by Thomas Conchon on 12/8/25.
//

import SwiftUI

struct SettingsView: View {
    @ObservedObject var viewModel: ProjectViewModel
    @State var showImporter = false
    @State var isShowingResetPopup = false
    @AppStorage("isFirstUse") var isFirstUse = true
    @State var isShowingAboutSheet = false
    
    var body: some View {
        VStack {
            List {
                aboutSection
                importantSection
            }
        }
        .sheet(isPresented: $isShowingAboutSheet) {
            aboutText.presentationDetents([.medium, .large])
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
    var importantSection: some View {
        Section {
            Button("Show Introduction") {
                isFirstUse = true
            }
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
    var aboutSection: some View {
        Section {
            Button(action: { isShowingAboutSheet = true }) {
                Text("About the app")
            }
            Link(destination: URL(string: "https://github.com/Lecloow/Komma")!) {
                Label("Learn more on GitHub", systemImage: "arrow.up.right.square")
            }
            
        }
    }
    var aboutText: some View {
        Text("Kómma was created by Thomas Conchon for the 2026 Swift Student Challenge.")
    }
}
