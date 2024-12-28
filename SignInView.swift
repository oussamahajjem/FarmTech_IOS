import SwiftUI

struct SignInView: View {
    @StateObject private var settings = AppSettings() // Initialize settings
    @StateObject private var authService = AuthService(networkService: NetworkService.shared)
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var errorMessage: String? = nil
    @State private var isLoggedIn = false
    @State private var isSigningUp = false
    @State private var isPasswordVisible = false

    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color.darkGreen, Color.darkGreen.opacity(0.8)]), startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 30) {
                    LogoView()
                        .padding(.top, 50)
                    
                    Text("Sign In")
                        .font(.system(size: 36, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                    
                    VStack(spacing: 20) {
                        CustomTextField(placeholder: "Email", text: $email, iconName: "envelope")
                            .keyboardType(.emailAddress)
                            .autocapitalization(.none)
                        
                        CustomSecureField(placeholder: "Password", text: $password, iconName: "lock", isPasswordVisible: $isPasswordVisible)
                    }
                    
                    Button(action: login) {
                        Text("Sign In")
                            .foregroundColor(.darkGreen)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.white)
                            .cornerRadius(10)
                            .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 5)
                    }
                    .padding(.top)
                    
                    NavigationLink(destination: ForgotPasswordView()) {
                        Text("Forgot Password?")
                            .foregroundColor(.lightGreen)
                    }
                    
                    if let errorMessage = errorMessage {
                        Text(errorMessage)
                            .foregroundColor(.red)
                            .padding(.top)
                    }
                    
                    Spacer()
                    
                    NavigationLink(destination: HomeView(), isActive: $isLoggedIn) {
                        EmptyView()
                    }
                    
                    Button(action: { isSigningUp = true }) {
                        Text("Don't have an account? Sign Up")
                            .foregroundColor(.lightGreen)
                            .underline()
                    }
                    .padding(.bottom, 20)
                    
                    NavigationLink(destination: SignUpView().environmentObject(settings), isActive: $isSigningUp) {
                        EmptyView()
                    }
                }
                .padding(.horizontal, 30)
            }
        }
        .navigationBarHidden(true)
    }

    func login() {
        authService.login(email: email, password: password) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let authResponse):
                    print("Login successful: \(authResponse.userId)")
                    print("Access Token: \(authResponse.accessToken)")
                    errorMessage = nil
                    isLoggedIn = true
                case .failure(let error):
                    errorMessage = "Error: \(error.localizedDescription)"
                    isLoggedIn = false
                }
            }
        }
    }
}

struct SignInView_Previews: PreviewProvider {
    static var previews: some View {
        SignInView()
    }
}

