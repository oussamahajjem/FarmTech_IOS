import SwiftUI

struct ParcelView: View {
    @State private var parcelName = ""
    @State private var parcelSize = ""
    @State private var soilType = "Loamy"
    @State private var cropType = ""
    
    let soilTypes = ["Clay", "Sandy", "Loamy", "Silt", "Peat"]
    
    var body: some View {
        VStack {
            Form {
                Section(header: Text("Parcel Information")) {
                    TextField("Parcel Name", text: $parcelName)
                    TextField("Size (hectares)", text: $parcelSize)
                        .keyboardType(.decimalPad)
                    Picker("Soil Type", selection: $soilType) {
                        ForEach(soilTypes, id: \.self) {
                            Text($0)
                        }
                    }
                    TextField("Crop Type", text: $cropType)
                }
                
                Section {
                    Button(action: saveParcel) {
                        Text("Save Parcel")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.darkGreen)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                }
                
                Section(header: Text("Existing Parcels")) {
                    ParcelCardView(name: "Wheat Field", size: "10", soilType: "Loamy", cropType: "Wheat")
                    ParcelCardView(name: "Corn Meadow", size: "15", soilType: "Sandy", cropType: "Corn")
                    ParcelCardView(name: "Soybean Plot", size: "8", soilType: "Clay", cropType: "Soybean")
                }
            }
            
            HStack {
                Spacer()
                NavigationLink(destination: TrendView()) {
                    VStack {
                        Image(systemName: "leaf.arrow.triangle.circlepath")
                            .font(.system(size: 30))
                        Text("Trending")
                            .font(.caption)
                    }
                    .frame(width: 80, height: 80)
                    .background(Color.darkGreen)
                    .foregroundColor(.white)
                    .cornerRadius(15)
                    .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 2)
                }
                .padding()
                Spacer()
            }
            .padding()
        }
        .navigationTitle("Parcels")
        .navigationBarTitleDisplayMode(.inline)
        .background(Color.darkGreen.opacity(0.1).ignoresSafeArea())
    }
    
    func saveParcel() {
        // Implement save functionality here
        print("Saving parcel: \(parcelName)")
    }
}

struct ParcelCardView: View {
    let name: String
    let size: String
    let soilType: String
    let cropType: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(name)
                .font(.headline)
                .foregroundColor(.darkGreen)
            HStack {
                Label("\(size) ha", systemImage: "ruler")
                Spacer()
                Label(soilType, systemImage: "mountain.2.fill")
            }
            .font(.subheadline)
            .foregroundColor(.secondary)
            Label(cropType, systemImage: "leaf.fill")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
    }
}

