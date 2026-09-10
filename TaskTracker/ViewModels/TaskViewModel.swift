import Combine

class TaskViewModel: ObservableObject {
    @Published var tasks: [Task] = [
        Task(title: "Learn Swift"),
        Task(title: "Build an app"),
        Task(title: "Deploy to App Store")
    ]
    @Published var selectedTaskFilter: String = "All"
    
    var filteredTasks: [Task] {
        switch selectedTaskFilter {
            case "Completed":
                tasks.filter { $0.isCompleted }
            case "Incomplete":
                tasks.filter { !$0.isCompleted }
            default:
                tasks
        }
    }
}
