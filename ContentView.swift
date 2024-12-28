/*import SwiftUI

struct ContentView: View {
    @EnvironmentObject var settings: AppSettings // This is crucial

    @State private var isDarkMode: Bool = false  // Variable d'état pour suivre le mode

    var body: some View {
        NavigationView {
            VStack {
                Text(LocalizedStringKey("Welcome"))
                                .onChange(of: settings.language) { _ in
                                    // React to language change
                                }
                // Affichage du texte en fonction du mode
                Text(isDarkMode ? "Dark Mode" : "Light Mode")
                    .font(.largeTitle)
                    .padding()

                // Navigation vers les paramètres
                NavigationLink(destination: ParameterView(darkModeEnabled: $isDarkMode)) {
                    Text("Go to Settings")
                        .foregroundColor(.blue)
                        .padding()
                }

                Spacer()
            }
            .preferredColorScheme(isDarkMode ? .dark : .light)  // Applique le mode sombre ou clair
            .navigationTitle("Dark Mode")
        }
    }
}*/
import SwiftUI

struct ContentView: View {
    @EnvironmentObject var settings: AppSettings
    @State private var isDarkMode: Bool = false

    var body: some View {
        NavigationView {
            VStack {
                Text(LocalizedStringKey("Welcome"))
                    .font(.largeTitle)
                    .padding()

                Text(isDarkMode ? LocalizedStringKey("Dark Mode") : LocalizedStringKey("Light Mode"))
                    .font(.title)
                    .padding()

                NavigationLink(destination: ParameterView(darkModeEnabled: $isDarkMode)) {
                    Text(LocalizedStringKey("Go to Settings"))
                        .foregroundColor(.blue)
                        .padding()
                }

                Spacer()
            }
            .preferredColorScheme(isDarkMode ? .dark : .light)
            .navigationTitle(LocalizedStringKey("Dark Mode"))
        }
        .environment(\.locale, .init(identifier: settings.language == "Français" ? "fr" : (settings.language == "Arabe" ? "ar" : "en")))
    }
}
