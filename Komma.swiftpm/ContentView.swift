import SwiftUI

struct ContentView: View {
    @ObservedObject var projectViewModel: ProjectViewModel
    @ObservedObject var focusViewModel: FocusViewModel
    @AppStorage("isFirstUse") var isFirstUse = true
    
    var body: some View {
        if isFirstUse {
            IntroductionView()
                .onAppear {
                    projectViewModel.createDemo()
                }
        } else {
            if #available(iOS 26.0, *) {
                TabView {
                    Tab("Home", systemImage: "house") {
                        NavigationStack {
                            HomeView(viewModel: projectViewModel)
                        }
                    }
                    Tab("Focus", systemImage: "figure.mind.and.body") {
                        NavigationStack {
                            FocusView(viewModel: focusViewModel)
                        }
                    }
                    Tab("Settings", systemImage: "gear") {
                        NavigationStack {
                            SettingsView(viewModel: projectViewModel)
                        }
                    }
                    
                }
                .tabBarMinimizeBehavior(.onScrollDown)
            } else {
                TabView {
                    NavigationStack {
                        HomeView(viewModel: projectViewModel)
                    }
                    .tabItem {
                        Label("Home", systemImage: "house")
                    }
                    NavigationStack {
                        FocusView(viewModel: focusViewModel)
                    }
                    .tabItem {
                        Label("Focus", systemImage: "figure.mind.and.body")
                    }
                    NavigationStack {
                        SettingsView(viewModel: projectViewModel)
                    }
                    .tabItem {
                        Label("Settings", systemImage: "gear")
                    }
                }
            }
        }
    }
}

