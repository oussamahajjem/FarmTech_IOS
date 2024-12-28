import Foundation
import Combine

class LandInfoViewModel: ObservableObject {
    @Published var landInfos: [LandInfo] = []
    @Published var errorMessage: String?

    private let networkService = NetworkService.shared

    // Fonction pour récupérer les informations de parcelles
    func fetchLandInfos() {
        networkService.fetchLandInfos { result in
            switch result {
            case .success(let landInfos):
                DispatchQueue.main.async {
                    self.landInfos = landInfos
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self.errorMessage = error.localizedDescription
                }
            }
        }
    }

    // Fonction pour créer une nouvelle parcelle
    func createLandInfo(area: Double, soilType: String, latitude: Double, longitude: Double) {
            let newLandInfo = CreateLandInfoDto(area: area, soilType: soilType, latitude: latitude, longitude: longitude)
            
            networkService.createLandInfo(landInfo: newLandInfo) { [weak self] result in
                DispatchQueue.main.async {
                    switch result {
                    case .success:
                        self?.fetchLandInfos() // Rafraîchir la liste des parcelles après création
                    case .failure(let error):
                        self?.errorMessage = error.localizedDescription
                    }
                }
            }
        }

}
