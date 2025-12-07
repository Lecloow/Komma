import SwiftUI

@main
struct MyApp: App {
    @StateObject var model = ProjectViewModel()
    var body: some Scene {
        WindowGroup {
            ContentView(viewModel: model)
        }
    }
}
