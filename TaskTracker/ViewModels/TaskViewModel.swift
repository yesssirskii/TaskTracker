import Combine
import Foundation

// This is a ViewModel consisting of 2 computed variables: tasks, filteredTasks.
// tasks is storing the hard-coded tasks here, instead of having them in the ContentView(), makes it cleaner.
// filteredTasks is used in the completed/uncompleted/all filter and for the search functionality.
class TaskViewModel: ObservableObject {
    @Published var tasks: [Task] = [
        Task(title: "Learn Swift"),
        Task(title: "Build an app"),
        Task(title: "Deploy to App Store")
    ]
    @Published var selectedTaskFilter: String = "All" // @Published is the class equivalent of @State
    @Published var searchQuery = ""
    
    var filteredTasks: [Task] {
        var searchResult: [Task]
        
        switch selectedTaskFilter {
            case "Completed":
                searchResult = tasks.filter { $0.isCompleted }
            case "Incomplete":
                searchResult = tasks.filter { !$0.isCompleted }
            default:
                searchResult = tasks
        }
        
        if !searchQuery.isEmpty {
            searchResult = searchResult.filter { $0.title.localizedCaseInsensitiveContains(searchQuery) }
        }
        
        return searchResult
    }
}
