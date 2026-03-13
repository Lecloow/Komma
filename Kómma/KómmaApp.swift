//
//  KómmaApp.swift
//  Kómma
//
//  Created by Thomas Conchon on 3/12/26.
//

import SwiftUI
import SwiftData

@main
struct Kómma: App {
//    var sharedModelContainer: ModelContainer = {
//        let schema = Schema([
//            Item.self,
//        ])
//        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
//
//        do {
//            return try ModelContainer(for: schema, configurations: [modelConfiguration])
//        } catch {
//            fatalError("Could not create ModelContainer: \(error)")
//        }
//    }()

    @State private var showLaunchScreen = true
    @State var projectViewModel = ProjectViewModel()
    @State var focusViewModel = FocusViewModel()

    var body: some Scene {
        WindowGroup {
            if showLaunchScreen {
                SplashScreenView()
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                            showLaunchScreen = false
                        }
                    }
            } else {
                ContentView(projectViewModel: projectViewModel, focusViewModel: focusViewModel)
            }
        }
//        .modelContainer(sharedModelContainer)
    }
}
