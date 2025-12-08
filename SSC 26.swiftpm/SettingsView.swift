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
    
    var body: some View {
        VStack {
            List {
                Button("Exporter") {
                    if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                       let root = scene.windows.first?.rootViewController {
                        viewModel.exportProjects(viewModel.projects, from: root)
                    }
                }
                Button("Importer") {
                    showImporter = true
                }
                Button("Reset Sample Project") {
                    viewModel.resetProjects()
                    viewModel.loadProjects()
                    showImporter = false
                }
            }
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
