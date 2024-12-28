import SwiftUI

struct WelcomeView: View {
    @StateObject private var settings = AppSettings() // Initialize settings


    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient(gradient: Gradient(colors: [Color.darkGreen, Color.darkGreen.opacity(0.8)]), startPoint: .top, endPoint: .bottom)
                    .ignoresSafeArea()
                
                VStack(spacing: 40) {
                    Spacer()
                    
                    LogoView()
                        .scaleEffect(1.5)
                    
                    VStack(spacing: 10) {
                        Text("WELCOME TO")
                            .font(.title2)
                            .fontWeight(.medium)
                            .foregroundColor(Color.lightGreen)
                        
                        Text("FarmTech")
                            .font(.system(size: 48, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                    }
                    
                    Spacer()
                    
                    VStack(spacing: 20) {
                        NavigationLink(destination: SignInView().environmentObject(settings)) {
                            Text("Sign In With Email")
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.white)
                                .foregroundColor(.darkGreen)
                                .cornerRadius(10)
                                .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 5)
                        }
                        
                        NavigationLink(destination: SignUpView().environmentObject(settings)) {
                            Text("Don't have an account? Sign Up")
                                .foregroundColor(.lightGreen)
                                .underline()
                        }
                    }
                    .padding(.horizontal, 30)
                    .padding(.bottom, 50)
                }
            }
            .navigationBarHidden(true)
        }
    }
}

struct LogoView: View {
    var body: some View {
        ZStack {
            Circle()
                .fill(LinearGradient(gradient: Gradient(colors: [Color.white, Color.lightGreen]), startPoint: .topLeading, endPoint: .bottomTrailing))
                .frame(width: 120, height: 120)
                .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 10)
            
            Image(systemName: "leaf.arrow.triangle.circlepath")
                .resizable()
                .scaledToFit()
                .frame(width: 60, height: 60)
                .foregroundColor(.darkGreen)
        }
    }
}

