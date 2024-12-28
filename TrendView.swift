import SwiftUI

struct TrendView: View {
    let trendingImages = [
        ("Wheat field", "https://images.unsplash.com/photo-1500382017468-9049fed747ef?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1000&q=80"),
        ("Corn crops", "https://images.unsplash.com/photo-1601329820103-f5204d2a3b2c?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1000&q=80"),
        ("Soybean plantation", "https://images.unsplash.com/photo-1599488615731-7e5c2823ff28?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1000&q=80"),
        ("Apple orchard", "https://www.google.com/url?sa=i&url=https%3A%2F%2Fwww.tannersorchard.com%2Fapple-orchards-davenport-ia%2F&psig=AOvVaw1580xOlGH1a0fviHJ7j4Kv&ust=1732901462772000&source=images&cd=vfe&opi=89978449&ved=0CBQQjRxqFwoTCNis2pLH_4kDFQAAAAAdAAAAABAE"),
        ("Vineyard", "https://www.google.com/url?sa=i&url=https%3A%2F%2Fagvalueconsulting.com%2Fvineyard-appraisal-services%2F&psig=AOvVaw2cgwMMMBwP_962gBKpDNLX&ust=1732901431375000&source=images&cd=vfe&opi=89978449&ved=0CBQQjRxqFwoTCMCs4IPH_4kDFQAAAAAdAAAAABAE"),
        ("Rice paddy", "https://www.google.com/url?sa=i&url=https%3A%2F%2Fwww.britannica.com%2Ftopic%2Fpaddy&psig=AOvVaw0P7BriMZMo1w_KDSZa6Nhu&ust=1732901365433000&source=images&cd=vfe&opi=89978449&ved=0CBQQjRxqFwoTCNjN2eXG_4kDFQAAAAAdAAAAABAE")
    ]
    
    let columns = [GridItem(.flexible())]
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 20) {
                ForEach(trendingImages, id: \.0) { title, imageURL in
                    VStack {
                        AsyncImage(url: URL(string: imageURL)) { phase in
                            switch phase {
                            case .empty:
                                ProgressView()
                                    .frame(height: 200)
                            case .success(let image):
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(height: 200)
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                            case .failure:
                                Image(systemName: "photo")
                                    .font(.largeTitle)
                                    .frame(height: 200)
                            @unknown default:
                                EmptyView()
                            }
                        }
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.darkGreen, lineWidth: 2)
                        )
                        .padding(.vertical, 10)
                        Text(title)
                            .font(.caption)
                            .foregroundColor(.darkGreen)
                            .padding(.top, 5)
                    }
                    .padding(.vertical, 10)
                }
            }
            .padding()
        }
        .navigationTitle("Trending in Agriculture")
        .navigationBarTitleDisplayMode(.inline)
        .background(Color.darkGreen.opacity(0.1).ignoresSafeArea())
    }
}

struct TrendView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            TrendView()
        }
    }
}

