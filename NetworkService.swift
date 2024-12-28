import Foundation
import UIKit

class NetworkService {
    static let shared = NetworkService()
    
    private let baseURL = "http://192.168.1.12:3000"
    
    private init() {}
    
    func login(email: String, password: String, completion: @escaping (Result<Data, Error>) -> Void) {
        let url = URL(string: "\(baseURL)/auth/login")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body: [String: Any] = ["email": email, "password": password]
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: body)
        } catch let error {
            completion(.failure(error))
            return
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "NetworkService", code: 0, userInfo: [NSLocalizedDescriptionKey: "No data received"])))
                return
            }
            
            completion(.success(data))
        }.resume()
    }

    enum NetworkError: Error {
           case invalidURL
           case invalidResponse
           case invalidData
       }
        
        // GetUserProfile method
    func getUserProfile(token: String, completion: @escaping (Result<UserProfile, Error>) -> Void) {
        guard let url = URL(string: "\(baseURL)/auth/profile") else {
            completion(.failure(NetworkError.invalidURL))
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data else {
                completion(.failure(NetworkError.invalidResponse))
                return
            }

            do {
                let userProfile = try JSONDecoder().decode(UserProfile.self, from: data)
                completion(.success(userProfile))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }

    
    func editProfile(
        token: String,
        name: String?,
        newPassword: String?,
        oldPassword: String?,
        profilePicture: Data?,
        completion: @escaping (Result<UpdateProfileResponse, Error>) -> Void
    ) {
        guard let url = URL(string: "\(baseURL)/auth/edit-profile") else {
            completion(.failure(NetworkError.invalidURL))
            return
        }

        let boundary = UUID().uuidString
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        var body = Data()

        // Add name if provided
        if let name = name {
            body.append("--\(boundary)\r\n".data(using: .utf8)!)
            body.append("Content-Disposition: form-data; name=\"name\"\r\n\r\n".data(using: .utf8)!)
            body.append("\(name)\r\n".data(using: .utf8)!)
        }

        // Add new password if both new and old passwords are provided
        if let newPassword = newPassword, let oldPassword = oldPassword {
            body.append("--\(boundary)\r\n".data(using: .utf8)!)
            body.append("Content-Disposition: form-data; name=\"newPassword\"\r\n\r\n".data(using: .utf8)!)
            body.append("\(newPassword)\r\n".data(using: .utf8)!)

            body.append("--\(boundary)\r\n".data(using: .utf8)!)
            body.append("Content-Disposition: form-data; name=\"oldPassword\"\r\n\r\n".data(using: .utf8)!)
            body.append("\(oldPassword)\r\n".data(using: .utf8)!)
        }

        // Add profile picture if provided
        if let imageData = profilePicture {
            body.append("--\(boundary)\r\n".data(using: .utf8)!)
            body.append("Content-Disposition: form-data; name=\"profilePicture\"; filename=\"profile.jpg\"\r\n".data(using: .utf8)!)
            body.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
            body.append(imageData)
            body.append("\r\n".data(using: .utf8)!)
        }

        body.append("--\(boundary)--\r\n".data(using: .utf8)!)
        request.httpBody = body

        // Send the request
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data else {
                completion(.failure(NetworkError.invalidResponse))
                return
            }

            do {
                let decodedResponse = try JSONDecoder().decode(UpdateProfileResponse.self, from: data)
                completion(.success(decodedResponse))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }



    
    func signup(name: String, email: String, password: String, profileImage: Data?, completion: @escaping (Result<Data, Error>) -> Void) {
        let url = URL(string: "\(baseURL)/auth/signup")!
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        let boundary = "Boundary-\(UUID().uuidString)"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        var body = Data()
        
        // Add name, email, password to body
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"name\"\r\n\r\n".data(using: .utf8)!)
        body.append("\(name)\r\n".data(using: .utf8)!)
        
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"email\"\r\n\r\n".data(using: .utf8)!)
        body.append("\(email)\r\n".data(using: .utf8)!)
        
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"password\"\r\n\r\n".data(using: .utf8)!)
        body.append("\(password)\r\n".data(using: .utf8)!)
        
        // Add profile image to body
        if let imageData = profileImage {
            body.append("--\(boundary)\r\n".data(using: .utf8)!)
            body.append("Content-Disposition: form-data; name=\"profilePicture\"; filename=\"profile.jpg\"\r\n".data(using: .utf8)!)
            body.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
            body.append(imageData)
            body.append("\r\n".data(using: .utf8)!)
        }

        body.append("--\(boundary)--\r\n".data(using: .utf8)!)
        
        request.httpBody = body
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 201 {
                completion(.success(data ?? Data()))
            } else {
                let error = NSError(domain: "NetworkService", code: 0, userInfo: [NSLocalizedDescriptionKey: "Signup failed with status code: \((response as? HTTPURLResponse)?.statusCode ?? 0)"])
                completion(.failure(error))
            }
        }.resume()
    }


    func forgotPassword(email: String, completion: @escaping (Result<String, Error>) -> Void) {
            let url = URL(string: "\(baseURL)/auth/forgot-password")!
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            
            let body: [String: Any] = ["email": email]
            request.httpBody = try? JSONSerialization.data(withJSONObject: body)
            
            URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                
                guard let data = data else {
                    completion(.failure(NSError(domain: "NetworkService", code: 0, userInfo: [NSLocalizedDescriptionKey: "No data received"])))
                    return
                }
                
                do {
                    if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                       let message = json["message"] as? String {
                        completion(.success(message))
                    } else {
                        completion(.failure(NSError(domain: "NetworkService", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid response format"])))
                    }
                } catch {
                    completion(.failure(error))
                }
            }.resume()
        }
    func getWeather(latitude: Double, longitude: Double, completion: @escaping (Result<WeatherDto, Error>) -> Void) {
            let url = URL(string: "\(baseURL)/azure-maps/weather?lat=\(latitude)&lng=\(longitude)")!
            
            URLSession.shared.dataTask(with: url) { data, response, error in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                
                guard let data = data else {
                    completion(.failure(NSError(domain: "NetworkService", code: 0, userInfo: [NSLocalizedDescriptionKey: "No data received"])))
                    return
                }
                
                do {
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    let weatherData = try decoder.decode(WeatherDto.self, from: data)
                    completion(.success(weatherData))
                } catch {
                    print("Decoding error: \(error)")
                    completion(.failure(error))
                }
            }.resume()
        }

    func analyzeImage(imageUrl: String?, imageData: Data?, completion: @escaping (Result<String, Error>) -> Void) {
        guard let url = URL(string: "\(baseURL)/vision/analyze") else {
            completion(.failure(NSError(domain: "Invalid URL", code: 0, userInfo: nil)))
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let boundary = "Boundary-\(UUID().uuidString)"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        var body = Data()

        if let imageUrl = imageUrl {
            body.append("--\(boundary)\r\n".data(using: .utf8)!)
            body.append("Content-Disposition: form-data; name=\"imageUrl\"\r\n\r\n".data(using: .utf8)!)
            body.append("\(imageUrl)\r\n".data(using: .utf8)!)
        }

        if let imageData = imageData {
            body.append("--\(boundary)\r\n".data(using: .utf8)!)
            body.append("Content-Disposition: form-data; name=\"file\"; filename=\"image.jpg\"\r\n".data(using: .utf8)!)
            body.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
            body.append(imageData)
            body.append("\r\n".data(using: .utf8)!)
        }

        body.append("--\(boundary)--\r\n".data(using: .utf8)!)
        request.httpBody = body

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "NetworkService", code: 0, userInfo: [NSLocalizedDescriptionKey: "No data received"])))
                return
            }
            
            do {
                // Parse the response from the Azure API
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                   let description = json["description"] as? [String: Any],
                   let captions = description["captions"] as? [[String: Any]],
                   let firstCaption = captions.first,
                   let captionText = firstCaption["text"] as? String {
                    
                    // Retourner le texte de la caption pour affichage
                    completion(.success(captionText))
                } else {
                    completion(.failure(NSError(domain: "Invalid JSON format", code: 0, userInfo: nil)))
                }
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }

    // Exemple d'utilisation
    
    func fetchLandInfos(completion: @escaping (Result<[LandInfo], Error>) -> Void) {
           guard let url = URL(string: "\(baseURL)/land-info") else {
               completion(.failure(NetworkError.invalidURL))
               return
           }

           let task = URLSession.shared.dataTask(with: url) { data, response, error in
               if let error = error {
                   completion(.failure(error))
                   return
               }

               guard let data = data else {
                   completion(.failure(NetworkError.invalidResponse))
                   return
               }

               do {
                   let landInfos = try JSONDecoder().decode([LandInfo].self, from: data)
                   completion(.success(landInfos))
               } catch {
                   completion(.failure(error))
               }
           }

           task.resume()
       }

       func createLandInfo(landInfo: CreateLandInfoDto, completion: @escaping (Result<Void, Error>) -> Void) {
           guard let url = URL(string: "\(baseURL)/land-info") else {
               completion(.failure(NetworkError.invalidURL))
               return
           }

           var request = URLRequest(url: url)
           request.httpMethod = "POST"
           request.setValue("application/json", forHTTPHeaderField: "Content-Type")

           do {
               let jsonData = try JSONEncoder().encode(landInfo)
               request.httpBody = jsonData
           } catch {
               completion(.failure(error))
               return
           }

           let task = URLSession.shared.dataTask(with: request) { _, response, error in
               if let error = error {
                   completion(.failure(error))
                   return
               }

               guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                   completion(.failure(NetworkError.invalidResponse))
                   return
               }

               completion(.success(()))
           }

           task.resume()
       }

    func predictImage(image: UIImage, completion: @escaping (Result<[String: String], Error>) -> Void) {
        guard let url = URL(string: "\(baseURL)/predict") else {
            completion(.failure(NetworkError.invalidURL))
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let boundary = "Boundary-\(UUID().uuidString)"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

        var body = Data()
        if let imageData = image.jpegData(compressionQuality: 0.8) {
            body.append("--\(boundary)\r\n".data(using: .utf8)!)
            body.append("Content-Disposition: form-data; name=\"file\"; filename=\"image.jpg\"\r\n".data(using: .utf8)!)
            body.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
            body.append(imageData)
            body.append("\r\n".data(using: .utf8)!)
        }
        body.append("--\(boundary)--\r\n".data(using: .utf8)!)
        request.httpBody = body

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NetworkError.invalidResponse))
                return
            }
            
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                   let prediction = json["prediction"] as? String,
                   let status = json["status"] as? String {
                    let resultDict = ["prediction": prediction, "status": status]
                    completion(.success(resultDict))
                } else {
                    completion(.failure(NetworkError.invalidResponse))
                }
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }

}

