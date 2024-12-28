import SwiftUI

struct SignUpView: View {
    @StateObject private var authService = AuthService(networkService: NetworkService.shared)
    @State private var name: String = ""
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var errorMessage: String? = nil
    @State private var isSignedUp = false
    @State private var isPasswordVisible = false
    @State private var profileImage: UIImage? = nil // State for profile image
    @State private var isImagePickerPresented = false // To control image picker display
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color.darkGreen, Color.darkGreen.opacity(0.8)]), startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 30) {
                    LogoView()
                        .padding(.top, 50)
                    
                    Text("Sign Up")
                        .font(.system(size: 36, weight: .bold, design: .rounded))
                        .foregroundColor(.white)

                    // Profile Image Picker Button
                    Button(action: { isImagePickerPresented.toggle() }) {
                        ZStack {
                            if let profileImage = profileImage {
                                Image(uiImage: profileImage)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 120, height: 120)
                                    .clipShape(Circle())
                            } else {
                                Circle()
                                    .fill(Color.gray.opacity(0.2))
                                    .frame(width: 120, height: 120)
                                    .overlay(
                                        Image(systemName: "camera.fill")
                                            .foregroundColor(.gray)
                                            .font(.largeTitle)
                                    )
                            }
                        }
                    }
                    .sheet(isPresented: $isImagePickerPresented) {
                        ProfileImagePicker(image: $profileImage) // Show the image picker
                    }

                    VStack(spacing: 20) {
                        CustomTextField(placeholder: "Name", text: $name, iconName: "person")
                        CustomTextField(placeholder: "Email", text: $email, iconName: "envelope")
                            .keyboardType(.emailAddress)
                            .autocapitalization(.none)
                        CustomSecureField(placeholder: "Password", text: $password, iconName: "lock", isPasswordVisible: $isPasswordVisible)
                    }
                    
                    Button(action: signUp) {
                        Text("Sign Up")
                            .foregroundColor(.darkGreen)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(isValidInput ? Color.white : Color.gray)
                            .cornerRadius(10)
                            .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 5)
                    }
                    .disabled(!isValidInput)
                    .padding(.top)
                    
                    if let errorMessage = errorMessage {
                        Text(errorMessage)
                            .foregroundColor(.red)
                            .padding(.top)
                    }
                    
                    Spacer()
                    
                    Button(action: { presentationMode.wrappedValue.dismiss() }) {
                        Text("Already have an account? Sign In")
                            .foregroundColor(.lightGreen)
                            .underline()
                    }
                    .padding(.bottom, 20)
                }
                .padding(.horizontal, 30)
            }
        }
        .navigationBarHidden(true)
        .alert(isPresented: $isSignedUp) {
            Alert(
                title: Text("Success"),
                message: Text("You have successfully signed up!"),
                dismissButton: .default(Text("OK")) {
                    presentationMode.wrappedValue.dismiss()
                }
            )
        }
    }

    var isValidInput: Bool {
        !name.isEmpty && isValidEmail(email) && isValidPassword(password)
    }

    func signUp() {
        // Ensure a profile image is selected
        guard let profileImage = profileImage else {
            errorMessage = "Please select a profile picture"
            return
        }

        // Convert the profile image to Data (JPEG format)
        guard let imageData = profileImage.jpegData(compressionQuality: 0.8) else {
            errorMessage = "Invalid image format"
            return
        }

        authService.signup(name: name, email: email, password: password, profileImage: imageData) { result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    errorMessage = nil
                    isSignedUp = true
                case .failure(let error):
                    errorMessage = "Error: \(error.localizedDescription)"
                }
            }
        }
    }

    func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailTest.evaluate(with: email)
    }

    func isValidPassword(_ password: String) -> Bool {
        return password.count >= 6
    }
}


struct CustomTextField: View {
    let placeholder: String
    @Binding var text: String
    let iconName: String
    
    var body: some View {
        HStack {
            Image(systemName: iconName)
                .foregroundColor(.darkGreen)
                .frame(width: 30)
            TextField(placeholder, text: $text)
                .foregroundColor(.primary)
        }
        .padding()
        .background(Color(UIColor.systemBackground))
        .cornerRadius(10)
        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 5)
    }
}

struct CustomSecureField: View {
    let placeholder: String
    @Binding var text: String
    let iconName: String
    @Binding var isPasswordVisible: Bool
    
    var body: some View {
        HStack {
            Image(systemName: iconName)
                .foregroundColor(.darkGreen)
                .frame(width: 30)
            if isPasswordVisible {
                TextField(placeholder, text: $text)
                    .foregroundColor(.primary)
            } else {
                SecureField(placeholder, text: $text)
                    .foregroundColor(.primary)
            }
            Button(action: {
                isPasswordVisible.toggle()
            }) {
                Image(systemName: isPasswordVisible ? "eye.fill" : "eye.slash.fill")
                    .foregroundColor(.darkGreen)
            }
        }
        .padding()
        .background(Color(UIColor.systemBackground))
        .cornerRadius(10)
        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 5)
    }
}
