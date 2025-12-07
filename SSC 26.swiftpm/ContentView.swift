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
                
                Tab("Focus", systemImage: "message") {
                    NavigationStack {
                        Text("2")
                    }
                }
                
                Tab("Settings", systemImage: "person.crop.circle") {
                    NavigationStack {
                        Text("4")
                    }
                }
                
                Tab(role: .search) {
                    NavigationStack {
                        Text("5")
                    }
                }
            }
            .tabBarMinimizeBehavior(.onScrollDown)
        } else {
            // Fallback on earlier versions
        }
    }
}
