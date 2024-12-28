import SwiftUI

struct ProfileImageView: View {
    @StateObject private var loader = ImageLoader()
    let imageUrl: URL

    var body: some View {
        Group {
            if let image = loader.image {
                image
                    .resizable()
                    .scaledToFill()
                    .frame(width: 100, height: 100)
                    .clipShape(Circle())
            } else {
                Image(systemName: "person.circle.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                    .foregroundColor(.gray)
            }
        }
        .onAppear {
            loader.load(fromURL: imageUrl)
        }
    }
    }
