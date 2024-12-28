import SwiftUI
import Combine

class AppSettings: ObservableObject {
    @Published var language: String {
        didSet {
            UserDefaults.standard.set(language, forKey: "AppLanguage")
            self.updateLocale()
        }
    }

    init() {
        self.language = UserDefaults.standard.string(forKey: "AppLanguage") ?? "English"
        self.updateLocale()
    }

    private func updateLocale() {
        let locale: Locale
        switch language {
        case "Français":
            locale = Locale(identifier: "fr")
        case "Arabe":
            locale = Locale(identifier: "ar")
        default:
            locale = Locale(identifier: "en")
        }
        UserDefaults.standard.set([locale.identifier], forKey: "AppleLanguages")
        UserDefaults.standard.synchronize()
    }
}
