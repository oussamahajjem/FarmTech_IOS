import SwiftUI

extension Color {
    static let customGreen = Color("CustomGreen")
    static let customBackground = Color("Background")
}

struct CustomButtonStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.customGreen)
            .foregroundColor(.white)
            .cornerRadius(8)
    }
}

extension View {
    func customButtonStyle() -> some View {
        self.modifier(CustomButtonStyle())
    }
}

struct GradientBackgroundStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(
                LinearGradient(gradient: Gradient(colors: [Color.customGreen.opacity(0.7), Color.customBackground]), startPoint: .top, endPoint: .bottom)
            )
            .ignoresSafeArea()
    }
}

extension View {
    func gradientBackgroundStyle() -> some View {
        self.modifier(GradientBackgroundStyle())
    }
}

