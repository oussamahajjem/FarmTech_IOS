import SwiftUI
import PhotosUI

struct PredictView: View {
    @State private var selectedImage: UIImage?
    @State private var predictionResult: String?
    @State private var isLoading = false
    @State private var isImagePickerPresented = false
    @State private var treatmentAdvice: String?

    var body: some View {
        VStack(alignment: .center, spacing: 20) {
            Text("Check Your Plant's Health")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(Color.green)
                .multilineTextAlignment(.center)
                .padding(.top, 20)

            Text("Upload a photo of your plant, and let's diagnose its condition!")
                .font(.title3)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)

            ZStack {
                RoundedRectangle(cornerRadius: 15, style: .continuous)
                    .fill(selectedImage == nil ? Color.secondary.opacity(0.1) : .clear)
                    .frame(height: 200)
                    .shadow(radius: 5)
                    .overlay(
                        Group {
                            if let image = selectedImage {
                                Image(uiImage: image)
                                    .resizable()
                                    .scaledToFit()
                            } else {
                                Text("Select an image")
                                    .foregroundColor(.gray)
                            }
                        }
                    )

                RoundedRectangle(cornerRadius: 15)
                    .stroke(Color.gray, lineWidth: 1)
                    .frame(height: 200)
            }
            .padding()

            Text("Choose Image")
                .font(.headline)
                .foregroundColor(.blue)
                .underline()
                .onTapGesture {
                    isImagePickerPresented = true
                }
                .sheet(isPresented: $isImagePickerPresented) {
                    ImagePicker(image: $selectedImage)
                }
                .padding(.bottom, 10)

            Button(action: {
                if let image = selectedImage {
                    isLoading = true
                    predictImage(image: image)
                }
            }) {
                Text("Predict")
                    .fontWeight(.medium)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(selectedImage == nil ? Color.gray : Color.green)
                    .cornerRadius(8)
                    .shadow(radius: 3)
            }
            .disabled(selectedImage == nil)
            .padding(.horizontal)

            if isLoading {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .blue))
                    .scaleEffect(1.5)
            } else if let result = predictionResult {
                VStack {
                    Text(result)
                        .fontWeight(.medium)
                        .foregroundColor(.primary)
                        .padding()

                    if let advice = treatmentAdvice {
                        Text("Treatment Advice:")
                            .fontWeight(.bold)
                            .foregroundColor(Color.green)
                            .padding(.top)

                        Text(advice)
                            .foregroundColor(.secondary)
                            .padding()
                    }
                }
            }

            Spacer()
        }
        .padding()
    }

    func predictImage(image: UIImage) {
        isLoading = true
        NetworkService.shared.predictImage(image: image) { result in
            DispatchQueue.main.async {
                isLoading = false
                switch result {
                case .success(let resultDict):
                    predictionResult = "\(resultDict["status"] ?? "") \(resultDict["prediction"] ?? "")"
                    // Simulated logic to determine treatment advice based on the prediction
                    treatmentAdvice = determineTreatmentAdvice(forDisease: resultDict["status"])
                case .failure(let error):
                    predictionResult = "Error: \(error.localizedDescription)"
                }
            }
        }
    }

    // Simulated function to determine treatment advice
    func determineTreatmentAdvice(forDisease disease: String?) -> String? {
        guard let disease = disease else { return nil }
        switch disease {
            case "Scab":
                return "Prune affected leaves and apply fungicidal spray."
            case "Rust":
                return "Remove infected parts and use rust-resistant plant varieties."
            default:
                return "No treatment needed or disease unrecognized."
        }
    }
}

// ImagePicker implementation remains unchanged


struct ImagePicker: UIViewControllerRepresentable {
    @Binding var image: UIImage?
    @Environment(\.presentationMode) var presentationMode

    func makeUIViewController(context: Context) -> PHPickerViewController {
        var config = PHPickerConfiguration()
        config.filter = .images
        let picker = PHPickerViewController(configuration: config)
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {
        // Required but no implementation needed for this use case
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, PHPickerViewControllerDelegate {
        var parent: ImagePicker

        init(_ parent: ImagePicker) {
            self.parent = parent
        }

        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            parent.presentationMode.wrappedValue.dismiss()
            guard let provider = results.first?.itemProvider,
                  provider.canLoadObject(ofClass: UIImage.self) else { return }
            provider.loadObject(ofClass: UIImage.self) { (image, error) in
                if let image = image as? UIImage {
                    DispatchQueue.main.async {
                        self.parent.image = image
                    }
                }
            }
        }
    }
}
