import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = TaskViewModel() // Passing the data and computed variables from the ViewModel to the View
    
    @State private var taskCount: Int = 0
    @State private var completedTasksCount: Int = 0
    @State private var newTaskTitle: String = ""
    @State private var showAddTask: Bool = false
    @State private var selectedTaskFilter: String = "All"
    
    var body: some View {
        NavigationStack {
            List(){
                ForEach(viewModel.filteredTasks) { task in
                    HStack{
                        Button(action: { changeTaskStatus(task: task) }) {
                            Image(systemName: task.isCompleted ? "checkmark.circle.fill" : "circlebadge")
                                .foregroundColor(task.isCompleted ? .blue : .black)
                        }
                        Text(task.title)
                            .strikethrough(task.isCompleted)
                            .foregroundStyle(task.isCompleted ? .blue : .black)
                        Spacer() //puts the info button to the right
                        Button(action: taskInfo){
                            Image(systemName: "info.circle")
                        }
                    }
                    .swipeActions(edge: .trailing) {
                        Button(role: .destructive, action: { deleteTask(task: task) }) {
                            Label("Delete", systemImage: "trash")
                        }
                    }
                }
            }
            .searchable(text: $viewModel.searchQuery) // Makes the list of tasks searchable. This creates a search bar without needing TabView or none of that. Nice.
            .navigationTitle("Task tracker")
            .navigationBarTitleDisplayMode(.large)
            .navigationSubtitle("\(completedTasksCount) tasks completed.")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Menu {
                        Button(action: { viewModel.selectedTaskFilter = "All" }) {
                            Label("All tasks", systemImage: "list.bullet")
                        }
                        Button(action: { viewModel.selectedTaskFilter = "Completed"}) {
                            Label("Completed", systemImage: "checkmark.circle")
                        }
                        Button(action: { viewModel.selectedTaskFilter = "Incomplete" }) {
                            Label("Incomplete", systemImage: "circle")
                        }
                    } label: {
                        Label("Filter tasks", systemImage: "line.3.horizontal.decrease")
                    }
                    .glassEffect()
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: { showAddTask = true }) {
                        Label("Add task", systemImage: "plus")
                    }
                    // Sheet is a small dialog that pops up from the bottom
                    .sheet(isPresented: $showAddTask) { // $ to both read and write the value
                        NavigationStack {
                            VStack {
                                Form {
                                    Section {
                                        TextField("Title", text: $newTaskTitle)
                                    }
                                }
                            }
                            .navigationTitle("Add new task")
                            .navigationBarTitleDisplayMode(.inline)
                            .toolbar {
                                ToolbarItem(placement: .topBarLeading) {
                                    Button(action: { showAddTask = false}) {
                                        Image(systemName: "multiply")
                                    }
                                }
                                ToolbarItem(placement: .confirmationAction) {
                                    Button(action: {
                                        addTask()
                                        showAddTask = false
                                    }) {
                                        Image(systemName: "checkmark")
                                    }
                                }
                            }
                        }
                        .presentationDetents([.fraction(0.25)])
                    }
                }
            }
        }
    }
    
    private func addTask() {
        let newTask = Task(title: newTaskTitle)
        
        viewModel.tasks.append(newTask)
        newTaskTitle = "" // reseting the value
    }
    
    private func taskInfo(){
        
    }
    
    private func changeTaskStatus(task: Task) {
        if let index = viewModel.tasks.firstIndex(where: { $0.id == task.id }) {
            viewModel.tasks[index].isCompleted.toggle()
            completedTasksCount = viewModel.tasks.filter { $0.isCompleted }.count
            
            // If a task is completed, remove it from the list and then append again
            // in order for it to be at the end of the array.
            let task = viewModel.tasks.remove(at: index)
            task.isCompleted ? viewModel.tasks.append(task) : viewModel.tasks.insert(task, at: 0)
        }
    }
    
    private func deleteTask(task: Task) {
        viewModel.tasks.removeAll { $0.id == task.id }
    }
}

#Preview {
    ContentView()
}
