import SwiftUI
import MapKit

struct LandView: View {
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 36.8065, longitude: 10.1815),
        span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
    )
    @State private var showSuccessAlert = false

    @State private var latitude: String = ""  // Utilisation d'une chaîne pour la latitude
    @State private var longitude: String = "" // Utilisation d'une chaîne pour la longitude
    @State private var area: String = ""      // Nouveau champ pour la superficie
    @State private var soilType: String = ""  // Nouveau champ pour le type de sol
    
    @ObservedObject var viewModel: LandInfoViewModel // ViewModel pour gérer les données
    
    var body: some View {
        VStack {
            Text("Parcelles")
                .font(.largeTitle)
                .padding()
            
            // Affichage de la carte
            Map(coordinateRegion: $region, interactionModes: .all)
                .frame(height: 400)
                .cornerRadius(10)
                .padding()
                .onTapGesture { location in
                    // La localisation de la carte lors du tap
                    let coordinate = region.center // Utilisation du centre de la carte
                    latitude = String(coordinate.latitude)  // Met à jour latitude
                    longitude = String(coordinate.longitude) // Met à jour longitude
                }
            
            // Champs de texte pour entrer la latitude
            TextField("Entrez la latitude", text: $latitude)
                .keyboardType(.decimalPad)
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(8)
                .padding([.leading, .trailing])
            
            // Champs de texte pour entrer la longitude
            TextField("Entrez la longitude", text: $longitude)
                .keyboardType(.decimalPad)
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(8)
                .padding([.leading, .trailing])
            
            // Nouveau champ pour entrer la superficie (Area)
            TextField("Entrez la superficie (Area)", text: $area)
                .keyboardType(.decimalPad)
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(8)
                .padding([.leading, .trailing])
            
            // Nouveau champ pour entrer le type de sol (Soil Type)
            TextField("Entrez le type de sol", text: $soilType)
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(8)
                .padding([.leading, .trailing])
            
            // Bouton pour ajouter une parcelle
            Button(action: {
                // Vérifie que les champs sont remplis correctement
                guard let lat = Double(latitude), let long = Double(longitude), let areaValue = Double(area) else {
                    // Afficher un message d'erreur si la latitude, longitude ou la superficie ne sont pas valides
                    viewModel.errorMessage = "Veuillez entrer des valeurs valides pour la latitude, la longitude et la superficie."
                    return
                }
                // Appeler la fonction du ViewModel avec tous les paramètres
                viewModel.createLandInfo(area: areaValue, soilType: soilType, latitude: lat, longitude: long)
                showSuccessAlert = true
            }) {
                Text("Ajouter une parcelle")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding()
            
            // Affichage des messages d'erreur
            if let errorMessage = viewModel.errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .padding()
            }
            
            Spacer()
        }
        .navigationTitle("Carte des parcelles")
    }
}
