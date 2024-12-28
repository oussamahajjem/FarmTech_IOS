import SwiftUI
import Combine

class ImageLoader: ObservableObject {
    @Published var image: Image?
    
    func load(fromURL url: URL) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data, let uiImage = UIImage(data: data) {
                DispatchQueue.main.async {
                    self.image = Image(uiImage: uiImage)
                }
            }
        }.resume()
    }
}
