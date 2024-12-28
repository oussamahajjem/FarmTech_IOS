import SwiftUI

struct PriceView: View {
    @State private var prices: [CommodityPrice] = [
        CommodityPrice(name: "Wheat", price: "$5.00", unit: "$5.00 per bushel", icon: "leaf.fill"),
        CommodityPrice(name: "Corn", price: "$3.50", unit: "3.50 per bushel", icon: "flame.fill"),
        CommodityPrice(name: "Soybeans", price: "$10.00", unit: "$10.00 per bushel", icon: "drop.fill"),
        CommodityPrice(name: "Rice", price: "$8.50", unit: "$8.50 per hundredweight", icon: "sparkles"),
        CommodityPrice(name: "Barley", price: "$4.20", unit: "$4.20 per bushel", icon: "leaf.arrow.circlepath"),
        CommodityPrice(name: "Oats", price: "$3.00", unit: "$3.00 per bushel", icon: "seal.fill"),
        CommodityPrice(name: "Cotton", price: "$0.75", unit: "$0.75 per pound", icon: "cloud.fill"),
        CommodityPrice(name: "Sugar", price: "$0.25", unit: "$0.25 per pound", icon: "cube.fill")
    ]
    
    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient(gradient: Gradient(colors: [Color("darkGreenBackground"), Color("darkGreenAccent")]), startPoint: .top, endPoint: .bottom)
                    .edgesIgnoringSafeArea(.all)
                
                VStack(spacing: 20) {
                    Text("Market Prices")
                        .font(.custom("AvenirNext-Bold", size: 40))
                        .foregroundColor(.white)
                        .padding(.top, 40)
                    
                    Text("Predict and track agricultural commodity prices")
                        .font(.custom("AvenirNext-Italic", size: 20))
                        .foregroundColor(.white.opacity(0.9))
                    
                    ScrollView {
                        LazyVStack(spacing: 15) {
                            ForEach(prices) { price in
                                PriceCard(commodity: price)
                            }
                        }
                        .padding(.horizontal)
                    }
                }
            }
            .navigationBarHidden(true)
        }
    }
}

struct CommodityPrice: Identifiable {
    let id = UUID()
    let name: String
    let price: String
    let unit: String
    let icon: String
}

struct PriceCard: View {
    var commodity: CommodityPrice
    @State private var showDetails = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Image(systemName: commodity.icon)
                    .foregroundColor(Color("darkGreenBackground"))
                    .font(.system(size: 24))
                
                Text(commodity.name)
                    .font(.custom("AvenirNext-Bold", size: 20))
                    .foregroundColor(.black)
                
                Spacer()
                
                VStack(alignment: .trailing) {
                    Text(commodity.price)
                        .font(.custom("AvenirNext-DemiBold", size: 22))
                        .foregroundColor(Color("darkGreenBackground"))
                    
                    Text(commodity.unit)
                        .font(.custom("AvenirNext-Regular", size: 14))
                        .foregroundColor(.gray)
                }
            }
            
            HStack {
                Text("Tap for more details")
                    .font(.caption)
                    .foregroundColor(.gray)
                
                Spacer()
                
                Button(action: {
                    withAnimation {
                        showDetails.toggle()
                    }
                }) {
                    Image(systemName: "chart.line.uptrend.xyaxis")
                        .foregroundColor(Color("darkGreenBackground"))
                        .font(.system(size: 20))
                        .rotationEffect(.degrees(showDetails ? 180 : 0))
                }
            }
            
            if showDetails {
                VStack(alignment: .leading, spacing: 5) {
                    Text("Market Trends:")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    
                    Text("Stable with slight upward trend")
                        .font(.headline)
                        .foregroundColor(.black)
                    
                    Button(action: {
                        print("View Details tapped for \(commodity.name)")
                    }) {
                        Text("View Full Report")
                            .font(.footnote)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 8)
                            .background(Color("darkGreenBackground"))
                            .cornerRadius(8)
                    }
                    .padding(.top, 5)
                }
                .transition(.opacity)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(15)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
        .overlay(
            RoundedRectangle(cornerRadius: 15)
                .stroke(Color("lightGreen"), lineWidth: 2)
        )
    }
}

struct PriceView_Previews: PreviewProvider {
    static var previews: some View {
        PriceView()
    }
}

