import SwiftUI

struct ProfileView: View {
    @State private var userProfile: UserProfile?
    @State private var errorMessage: String?

    var body: some View {
        NavigationView {
            VStack {
                if let userProfile = userProfile {
                    Text("Welcome, \(userProfile.name)")
                        .font(.title)
                        .padding()
                    Text("Email: \(userProfile.email)")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .padding(.bottom)
                    if let urlString = userProfile.profilePictureUrl,
                       let url = URL(string: urlString) {
                        ProfileImageView(imageUrl: url)
                    } else {
                        Image(systemName: "person.circle.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100, height: 100)
                            .foregroundColor(.gray)
                    }
                } else if let errorMessage = errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .padding()
                } else {
                    ProgressView()
                        .padding()
                }
                Spacer()
            }
            .onAppear {
                loadUserProfile()
            }
            .navigationTitle("Profile")
            .navigationBarTitleDisplayMode(.inline)
        }
    }

    private func loadUserProfile() {
        guard let token = UserDefaults.standard.string(forKey: "JWTToken") else {
            self.errorMessage = "Authentication token not available"
            return
        }

        NetworkService.shared.getUserProfile(token: token) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let profile):
                    self.userProfile = profile
                case .failure(let error):
                    self.errorMessage = "Failed to load profile: \(error.localizedDescription)"
                }
            }
        }
    }
}
