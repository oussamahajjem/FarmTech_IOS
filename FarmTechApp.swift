import SwiftUI

@main
struct FarmTechApp: App {
    @StateObject private var settings = AppSettings() // Existing settings initialization

    var body: some Scene {
        WindowGroup {
            NavigationStack {
                WelcomeView() // Initial view
            }
            .environmentObject(settings)
            .environment(\.locale, .init(identifier: determineLanguage(from: settings)))
        }
    }

    private func determineLanguage(from settings: AppSettings) -> String {
        switch settings.language {
            case "Français": return "fr"
            case "Arabe": return "ar"
            default: return "en"
        }
    }
}
