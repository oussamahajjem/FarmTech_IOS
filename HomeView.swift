import SwiftUI

struct HomeView: View {
    @State private var searchText = ""
    @State private var isDarkMode = false
    @State private var isAnimating = false
    @State private var showSideMenu = false

    struct Feature: Identifiable {
        let id = UUID()
        let title: String
        let description: String
        let iconName: String
        let route: String
    }

    let features: [Feature] = [
        Feature(title: "Weather Forecast", description: "AI-powered local weather predictions", iconName: "cloud.sun.fill", route: "weather"),
        Feature(title: "Agri Analysis", description: "Detect diseases and nutrient deficiencies", iconName: "leaf.fill", route: "crop_health"),
        Feature(title: "Recommendation", description: "Optimize your watering schedule", iconName: "drop.fill", route: "irrigation"),
        Feature(title: "Pest Detection", description: "Identify and manage pests effectively", iconName: "ant.fill", route: "pest"),
        Feature(title: "Market Prices", description: "Predict and track agricultural commodity prices", iconName: "chart.line.uptrend.xyaxis", route: "market"),
        Feature(title: "Soil Analysis", description: "Get fertilizer recommendations based on soil health", iconName: "mountain.2.fill", route: "soil")
    ]

    var filteredFeatures: [Feature] {
        if searchText.isEmpty {
            return features
        } else {
            return features.filter { $0.title.lowercased().contains(searchText.lowercased()) }
        }
    }

    var body: some View {
        NavigationView {
            ZStack {
                Color.darkGreen.opacity(0.1).ignoresSafeArea()

                VStack {
                    searchBar
                    featureList
                }

                GeometryReader { geometry in
                    HStack(spacing: 0) {
                        SideMenuView(isDarkMode: $isDarkMode, showMenu: $showSideMenu)
                            .frame(width: geometry.size.width * 0.75)
                            .offset(x: showSideMenu ? 0 : -geometry.size.width * 0.75)

                        Spacer()
                    }
                }
                .background(
                    Color.black.opacity(showSideMenu ? 0.5 : 0)
                        .ignoresSafeArea()
                        .onTapGesture {
                            withAnimation {
                                showSideMenu = false
                            }
                        }
                )
                .zIndex(1)
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        withAnimation {
                            showSideMenu.toggle()
                        }
                    }) {
                        Image(systemName: "line.horizontal.3")
                            .font(.title2)
                            .foregroundColor(.primary)
                    }
                }

                ToolbarItem(placement: .principal) {
                    Text("FarmTechAI")
                        .font(.headline)
                        .foregroundColor(.primary)
                }

                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: ParameterView(darkModeEnabled: $isDarkMode)) {
                        Image(systemName: "gear")
                            .font(.title2)
                            .foregroundColor(.primary)
                    }
                }
            }
            .onAppear {
                withAnimation(.easeOut(duration: 0.8)) {
                    isAnimating = true
                }
            }
        }
    }

    private var searchBar: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)
            TextField("Search or add a feature", text: $searchText)
                .foregroundColor(.primary)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(8)
        }
        .padding()
        .background(Color(UIColor.systemBackground))
        .cornerRadius(10)
        .padding(.horizontal)
    }

    private var featureList: some View {
        ScrollView {
            LazyVStack(spacing: 20) {
                ForEach(filteredFeatures) { feature in
                    featureCard(for: feature)
                }
            }
            .padding()
        }
    }

    private func featureCard(for feature: Feature) -> some View {
        NavigationLink(destination: destinationView(for: feature)) {
            HStack {
                Image(systemName: feature.iconName)
                    .foregroundColor(.white)
                    .font(.system(size: 30))
                    .frame(width: 60, height: 60)
                    .background(Color.darkGreen)
                    .clipShape(RoundedRectangle(cornerRadius: 15))

                VStack(alignment: .leading, spacing: 5) {
                    Text(feature.title)
                        .font(.headline)
                        .foregroundColor(.primary)

                    Text(feature.description)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }

                Spacer()

                Image(systemName: "chevron.right")
                    .foregroundColor(.primary)
            }
            .padding()
            .background(Color(UIColor.secondarySystemBackground))
            .cornerRadius(15)
            .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 5)
            .opacity(isAnimating ? 1 : 0)
            .offset(y: isAnimating ? 0 : 20)
            .animation(.easeOut(duration: 0.5).delay(Double(features.firstIndex(where: { $0.id == feature.id }) ?? 0) * 0.1), value: isAnimating)
        }
    }

    @ViewBuilder
    func destinationView(for feature: Feature) -> some View {
        switch feature.route {
        case "weather":
            WeatherView()
        case "irrigation":
            RecommendationsView(weather: WeatherDto.mockData)
        case "pest":
            PredictView()
        case "crop_health":
            CropHealthAnalysisView()
        case "market":
            PriceView()
        case "soil":
            let viewModel = LandInfoViewModel()
            LandView(viewModel: viewModel)
        default:
            Text("Coming soon: \(feature.title)")
        }
    }
}

struct SideMenuView: View {
    @Binding var isDarkMode: Bool
    @Binding var showMenu: Bool
    @State private var userProfile: UserProfile?
    @State private var isEditProfileActive = false

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Profile Header Section
            ZStack(alignment: .top) {
                Color.black.edgesIgnoringSafeArea(.top)
                
                VStack(alignment: .leading, spacing: 4) {
                    if let userProfile = userProfile {
                        Text("Welcome, \(userProfile.name)")
                            .font(.title3.bold())
                            .foregroundColor(.white)
                        
                        Text("Email: \(userProfile.email)")
                            .font(.subheadline)
                            .foregroundColor(.white.opacity(0.7))
                        
                        if let urlString = userProfile.profilePictureUrl,
                           let url = URL(string: urlString) {
                            ProfileImageView(imageUrl: url)
                                .frame(width: 100, height: 100)
                                .padding(.top, 12)
                        }
                    } else {
                        ProgressView()
                            .tint(.white)
                    }
                }
                .padding(.top, 60)
                .padding(.horizontal)
                .padding(.bottom, 20)
            }
            
            Divider()
                .background(Color.gray.opacity(0.3))

            // Menu Items
            VStack(spacing: 0) {
                NavigationLink(destination: EditProfileView(), isActive: $isEditProfileActive) {
                    menuLink(icon: "person", title: "Edit Profile")
                }
                menuLink(icon: "gearshape", title: "Settings")
                menuLink(icon: "questionmark.circle", title: "Help & Support")
                menuLink(icon: "info.circle", title: "About")
            }
            .padding(.top, 20)

            Spacer()

            // Logout Button
            Button(action: {
                // Implement logout functionality here
            }) {
                HStack {
                    Image(systemName: "rectangle.portrait.and.arrow.right")
                        .foregroundColor(.red)
                    Text("Logout")
                        .foregroundColor(.red)
                }
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(.bottom, 50)
        }
        .background(Color.black)
        .onAppear {
            loadUserProfile()
        }
    }

    private func menuLink(icon: String, title: String) -> some View {
        HStack {
            Image(systemName: icon)
                .frame(width: 24)
            Text(title)
            Spacer()
            Image(systemName: "chevron.right")
                .font(.system(size: 14))
        }
        .foregroundColor(.white)
        .padding(.horizontal)
        .padding(.vertical, 12)
    }

    private func loadUserProfile() {
        guard let token = UserDefaults.standard.string(forKey: "JWTToken") else {
            return
        }

        NetworkService.shared.getUserProfile(token: token) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let profile):
                    self.userProfile = profile
                case .failure:
                    break
                }
            }
        }
    }
}
