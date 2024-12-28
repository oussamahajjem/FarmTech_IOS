import Foundation

class AuthService: ObservableObject {
    @Published var isAuthenticated = false
    @Published var accessToken: String?
    @Published var refreshToken: String?
    @Published var userId: String?

    private let networkService: NetworkService
    
    init(networkService: NetworkService) {
        self.networkService = networkService
    }
    
    func login(email: String, password: String, completion: @escaping (Result<LoginResponse, Error>) -> Void) {
        networkService.login(email: email, password: password) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let data):
                    do {
                        let authResponse = try JSONDecoder().decode(LoginResponse.self, from: data)
                        self.accessToken = authResponse.accessToken
                        self.refreshToken = authResponse.refreshToken
                        self.userId = authResponse.userId
                        UserDefaults.standard.set(authResponse.accessToken, forKey: "JWTToken")


                        self.isAuthenticated = true
                        completion(.success(authResponse))
                    } catch {
                        completion(.failure(error))
                    }
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
    }

    
    func signup(name: String, email: String, password: String, profileImage: Data?, completion: @escaping (Result<Void, Error>) -> Void) {
        networkService.signup(name: name, email: email, password: password, profileImage: profileImage) { result in
            switch result {
            case .success:
                completion(.success(()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    
    func forgotPassword(email: String, completion: @escaping (Result<String, Error>) -> Void) {
            networkService.forgotPassword(email: email) { result in
                switch result {
                case .success(let message):
                    completion(.success(message))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
    func logout() {
        DispatchQueue.main.async {
            //self.currentUser = nil
            //self.token = nil
            //self.isAuthenticated = false
        }
    }
}

struct User: Codable {
    let id: String
    let name: String
    let email: String
}

struct LoginResponse: Codable {
    let accessToken: String
    let refreshToken: String
    let userId: String

}

