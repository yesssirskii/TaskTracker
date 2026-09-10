import Foundation

struct Task : Identifiable { // protocols that requires id
    let id = UUID()
    var title: String
    var isCompleted: Bool = false
}
