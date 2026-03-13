import SwiftUI

//@main
struct llMyApp: App {
    @State var projectViewModel = ProjectViewModel()
    @State var focusViewModel = FocusViewModel()
    
    var body: some Scene {
        WindowGroup {
            ContentView(projectViewModel: projectViewModel, focusViewModel: focusViewModel)
        }
    }
}
