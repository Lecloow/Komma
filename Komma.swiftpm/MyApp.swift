import SwiftUI

@main
struct MyApp: App {
    @StateObject var projectViewModel = ProjectViewModel()
    @StateObject var focusViewModel = FocusViewModel()
    
    var body: some Scene {
        WindowGroup {
            ContentView(projectViewModel: projectViewModel, focusViewModel: focusViewModel)
        }
    }
}
