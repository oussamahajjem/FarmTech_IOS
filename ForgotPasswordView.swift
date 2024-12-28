import SwiftUI

struct ForgotPasswordView: View {
    @StateObject private var authService = AuthService(networkService: NetworkService.shared)
    @State private var email: String = ""
    @State private var message: String? = nil
    @State private var isLoading: Bool = false

    var body: some View {
        ZStack {
            // Background gradient
            LinearGradient(gradient: Gradient(colors: [Color.darkGreen, Color.darkGreen.opacity(0.8)]),
                           startPoint: .top,
                           endPoint: .bottom)
                .ignoresSafeArea()

            VStack(spacing: 20) {
                // Title
                Text("Forgot Password")
                    .font(.system(size: 32, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                    .padding(.bottom, 20)

                // Email TextField
                TextField("Email", text: $email)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(10)
                    .keyboardType(.emailAddress)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled(true)
                    .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 5)

                // Reset Password Button
                Button("Reset Password") {
                    resetPassword()
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(isLoading ? Color.gray : Color.white)
                .foregroundColor(isLoading ? .white : .darkGreen)
                .cornerRadius(10)
                .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 5)
                .disabled(isLoading)

                // Loading Indicator
                if isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        .padding()
                }

                // Message
                if let message = message {
                    Text(message)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.darkGreen.opacity(0.6))
                        .cornerRadius(10)
                        .padding(.top)
                }

                Spacer()
            }
            .padding(.horizontal, 20)
        }
        .navigationTitle("Forgot Password")
        .navigationBarTitleDisplayMode(.inline)
    }

    func resetPassword() {
        guard !email.isEmpty else {
            message = "Please enter your email address"
            return
        }

        isLoading = true
        message = nil

        authService.forgotPassword(email: email) { result in
            DispatchQueue.main.async {
                isLoading = false
                switch result {
                case .success(let message):
                    self.message = message
                case .failure(let error):
                    self.message = "Error: \(error.localizedDescription)"
                }
            }
        }
    }
}

