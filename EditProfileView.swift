import SwiftUI

struct EditProfileView: View {
    @State private var name: String = ""
    @State private var newPassword: String = ""
    @State private var oldPassword: String = ""
    @State private var profileImage: UIImage?
    @State private var isImagePickerPresented = false
    @State private var isLoading = false
    @State private var errorMessage: String?
    @State private var successMessage: String?
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var appSettings: AppSettings

    var body: some View {
        ZStack {
            // Background color for both light and dark mode
            Color("Background").edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 30) {
                profileImageSection
                nameSection
                passwordSection
                updateButton
                messageSection
                Spacer()
            }
            .padding()
        }
        .navigationBarTitle("Edit Profile", displayMode: .inline)
        .navigationBarItems(leading: cancelButton)
    }
    
    // Profile Image Section
    private var profileImageSection: some View {
        VStack {
            if let image = profileImage {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 120, height: 120)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color.blue, lineWidth: 2))
            } else {
                Image(systemName: "person.circle.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 120, height: 120)
                    .foregroundColor(.gray)
            }

            Button(action: { isImagePickerPresented = true }) {
                Text("Change Photo")
                    .foregroundColor(.blue)
                    .font(.system(size: 16, weight: .medium))
                    .padding(.vertical, 8)
            }
        }
        .padding(.top)
    }
    
    // Name Section
    private var nameSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Name")
                .font(.headline)
                .foregroundColor(.primary)
            
            CustomTextField(placeholder: "Enter your name", text: $name, iconName: "person")
        }
    }
    
    // Password Section
    private var passwordSection: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Change Password")
                .font(.headline)
                .foregroundColor(.primary)
            
            CustomSecureField(placeholder: "Current Password", text: $oldPassword, iconName: "lock", isPasswordVisible: .constant(false))
            CustomSecureField(placeholder: "New Password", text: $newPassword, iconName: "lock", isPasswordVisible: .constant(false))
        }
    }
    
    // Update Button
    private var updateButton: some View {
        Button(action: updateProfile) {
            if isLoading {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    .scaleEffect(1.5)
            } else {
                Text("Update Profile")
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(10)
                    .shadow(radius: 5)
            }
        }
        .disabled(isLoading)
    }
    
    // Message Section (Success/Error)
    private var messageSection: some View {
        Group {
            if let errorMessage = errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .padding(.top)
                    .font(.subheadline)
                    .multilineTextAlignment(.center)
            }
            
            if let successMessage = successMessage {
                Text(successMessage)
                    .foregroundColor(.green)
                    .padding(.top)
                    .font(.subheadline)
                    .multilineTextAlignment(.center)
            }
        }
    }
    
    // Cancel Button
    private var cancelButton: some View {
        Button("Cancel") {
            presentationMode.wrappedValue.dismiss()
        }
    }
    
    // Update Profile Logic
    private func updateProfile() {
        isLoading = true
        errorMessage = nil
        successMessage = nil
        
        guard let token = UserDefaults.standard.string(forKey: "JWTToken") else {
            errorMessage = "Authentication token not available"
            isLoading = false
            return
        }
        
        let imageData = profileImage?.jpegData(compressionQuality: 0.8)
        
        NetworkService.shared.editProfile(token: token, name: name.isEmpty ? nil : name, newPassword: newPassword.isEmpty ? nil : newPassword, oldPassword: oldPassword.isEmpty ? nil : oldPassword, profilePicture: imageData) { result in
            DispatchQueue.main.async {
                isLoading = false
                switch result {
                case .success(let response):
                    successMessage = response.message
                case .failure(let error):
                    errorMessage = error.localizedDescription
                }
            }
        }
    }
}

struct EditProfileView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            EditProfileView()
                .environmentObject(AppSettings())
                .preferredColorScheme(.light)
            EditProfileView()
                .environmentObject(AppSettings())
                .preferredColorScheme(.dark)
        }
    }
}
