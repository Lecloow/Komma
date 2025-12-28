import SwiftUI

struct ContentView: View {
    @ObservedObject var projectViewModel: ProjectViewModel
    @ObservedObject var focusViewModel: FocusViewModel
    
    var body: some View {
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
                
//                Tab("Today", systemImage: "message") {
//                    NavigationStack {
//                        Text("2")
//                    }
//                }
//                
//                Tab("Calendar", systemImage: "calendar") {
//                    NavigationStack {
//                        Text("3")
//                    }
//                }
                //TODO: If I have the time
                
                Tab("Settings", systemImage: "gear") {
                    NavigationStack {
                        SettingsView(viewModel: projectViewModel)
                    }
                }
                
            }
            .tabBarMinimizeBehavior(.onScrollDown)
        } else {
            // Fallback on earlier versions
        }
    }
}
