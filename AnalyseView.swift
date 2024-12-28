import SwiftUI

struct CropHealthAnalysisView: View {
    @State private var imageUrl: String = ""
    @State private var imageData: Data? = nil
    @State private var analysisResult: String? // Pour stocker le texte d'analyse
    @State private var errorMessage: String?

    var body: some View {
        VStack {
            Text("Crop Health Analysis")
                .font(.title)
                .padding()

            TextField("Enter Image URL", text: $imageUrl)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            Button("Upload Image for Analysis") {
                // Vérifiez si l'URL est valide et lancez l'analyse
                if !imageUrl.isEmpty {
                    // Appelez la méthode d'analyse de l'image
                    NetworkService.shared.analyzeImage(imageUrl: imageUrl, imageData: nil) { result in
                        switch result {
                        case .success(let captionText):
                            // Mettez à jour avec le résultat de l'analyse
                            analysisResult = captionText
                            errorMessage = nil // Réinitialiser l'erreur
                        case .failure(let error):
                            // Si une erreur se produit, mettez à jour l'erreur
                            analysisResult = nil
                            errorMessage = "Error: \(error.localizedDescription)"
                        }
                    }
                } else {
                    // Si l'URL est vide, afficher un message d'erreur
                    errorMessage = "Please provide a valid image URL"
                    analysisResult = nil
                }
            }
            .padding()

            // Affichez les résultats de l'analyse si disponibles
            if let analysisResult = analysisResult {
                Text("Analysis Result:")
                    .font(.headline)
                    .padding()

                Text(analysisResult)
                    .padding()
                    .foregroundColor(.green) // Optionnel: Vous pouvez colorer le texte d'analyse
            }

            // Affichez les messages d'erreur si disponibles
            if let errorMessage = errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .padding()
            }
        }
        .navigationBarTitle("Crop Health Analysis", displayMode: .inline)
        .padding()
    }
}
