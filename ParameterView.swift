import SwiftUI

struct ParameterView: View {
    @EnvironmentObject var settings: AppSettings
    @Binding var darkModeEnabled: Bool  // Recevoir l'état du mode sombre de ContentView
    @State private var notificationEnabled = true
    @State private var selectedLanguage = "English"
    @State private var updateFrequency = 1.0
    
    let languages = ["English", "Français", "Arabe"]
    
    var body: some View {
        Form {
            Section(header: Text("Notifications")) {
                Toggle("Enable Notifications", isOn: $notificationEnabled)
            }
            
            Section(header: Text("Appearance")) {
                Toggle("Dark Mode", isOn: $darkModeEnabled)
                    .onChange(of: darkModeEnabled) { newValue in
                        // Appliquer le mode sombre ou clair globalement
                        UIApplication.shared.windows.first?.rootViewController?.view.overrideUserInterfaceStyle = newValue ? .dark : .light
                    }
            }
            
           /* Section(header: Text("Language")) {
                            Picker("Select Language", selection: $settings.language) {
                                ForEach(languages, id: \.self) {
                                    Text($0).tag($0)
                                }
                            }
                        }*/
            Section(header: Text(LocalizedStringKey("Language"))) {
                            Picker(LocalizedStringKey("Select Language"), selection: $settings.language) {
                                ForEach(languages, id: \.self) {
                                    Text(LocalizedStringKey($0)).tag($0)
                                }
                            }
                        }
        }
        .navigationTitle(LocalizedStringKey("Setting"))
        .navigationBarTitleDisplayMode(.inline)
        .background(Color.darkGreen.opacity(0.1).ignoresSafeArea())
        .environment(\.locale, .init(identifier: settings.language == "Français" ? "fr" : (settings.language == "Arabe" ? "ar" : "en")))
    }
}

struct ParameterView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ParameterView(darkModeEnabled: .constant(false))
        }
    }
}
