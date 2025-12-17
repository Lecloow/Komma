import SwiftUI

struct ContentView: View {
    @ObservedObject var viewModel: ProjectViewModel
    
    var body: some View {
        if #available(iOS 26.0, *) {
            TabView {
                Tab("Home", systemImage: "house") {
                    NavigationStack {
                        HomeView(viewModel: viewModel)
                    }
                }
                
                Tab("Focus", systemImage: "figure.mind.and.body") {
                    NavigationStack {
                        Text("1")
                    }
                }
                
                Tab("Today", systemImage: "message") {
                    NavigationStack {
                        Text("2")
                    }
                }
                
                Tab("Calendar", systemImage: "calendar") {
                    NavigationStack {
                        Text("3")
                    }
                }
                
                Tab("Settings", systemImage: "person.crop.circle") {
                    NavigationStack {
                        SettingsView(viewModel: viewModel)
                    }
                }
                
            }
            .tabBarMinimizeBehavior(.onScrollDown)
        } else {
            // Fallback on earlier versions
        }
    }
}
