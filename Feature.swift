import Foundation

struct Feature: Identifiable {
    let id = UUID()
    let title: String
    let description: String
    let iconName: String
    let route: String
}

