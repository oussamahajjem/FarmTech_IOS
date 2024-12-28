import Foundation

struct UpdateProfileDto: Codable {
    let name: String
    let email: String
    let phoneNumber: String
}

struct UpdateProfileResponse: Codable {
    let message: String
    let user: UserProfile
}



