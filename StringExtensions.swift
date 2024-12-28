import Foundation

extension String {
    var localized: String {
        NSLocalizedString(self, tableName: nil, bundle: .main, value: "", comment: "")
    }
}
