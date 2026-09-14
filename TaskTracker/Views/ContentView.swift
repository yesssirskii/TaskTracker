import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = TaskViewModel() // Passing the data and computed variables from the ViewModel to the View
    
    @State private var taskCount: Int = 0
    @State private var completedTasksCount: Int = 0
    @State private var newTaskTitle: String = ""
    @State private var selectedTaskFilter: String = "All"
    @State private var selectedTask: Task? = nil
    @State private var showAddTask: Bool = false
    
    @FocusState private var isFocused: Bool

    var body: some View {
        NavigationStack {
            List() {
                ForEach(viewModel.filteredTasks) { task in
                    HStack{
                        Button(action: {
                            changeTaskStatus(task: task)
                            // Haptic feedback upon clicking
                            let hapticFeedbackOnTaskStatusChange = UIImpactFeedbackGenerator(style: .medium)
                            hapticFeedbackOnTaskStatusChange.impactOccurred() })
                        {
                            Image(systemName: task.isCompleted ? "checkmark.circle.fill" : "circle")
                                .foregroundColor(task.isCompleted ? .blue : .gray)
                        }
                        .buttonStyle(.plain) // Tells SwiftUI that the button is a separate tap target
                        Text(task.title)
                            .strikethrough(task.isCompleted)
                            .foregroundStyle(task.isCompleted ? .blue : .primary)
                        Spacer() //puts the info button to the right
                        NavigationLink(destination:
                            Group {
                                if let index = viewModel.tasks.firstIndex(where: { $0.id == task.id }) {
                                            TaskInfoView(infoTask: $viewModel.tasks[index])
                                        }
                        }){
                            Image(systemName: "info.circle",)
                                .foregroundStyle(Color.blue)
                        }
                        .navigationLinkIndicatorVisibility(.hidden)
                        .buttonStyle(.plain)
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
                        Picker ("Filter", selection: $viewModel.selectedTaskFilter) {
                            Label("All tasks", systemImage: "list.bullet")
                                .tag("All")
                            Label("Completed", systemImage: "checkmark.circle")
                                .tag("Completed")
                            Label("Incomplete", systemImage: "circle")
                                .tag("Incomplete")
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
                                            .focused($isFocused) // $ is two-way binding
                                    }
                                }
                            }
                            .navigationTitle("Add new task")
                            .navigationBarTitleDisplayMode(.inline)
                            .toolbar {
                                ToolbarItem(placement: .topBarLeading) {
                                    Button(action: { showAddTask = false }) {
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
                                    .buttonStyle(.glassProminent)
                                    .tint(.blue)
                                    .disabled(newTaskTitle.isEmpty)
                                }
                            }
                        }
                        .onAppear { isFocused = true }
                        .presentationDetents([.fraction(0.20)]) // sets how hight he sheet will go. In this case, how much higher from the bottom.
                    }
                }
            }
        }
    }
    
    private func addTask() {
        let newTask = Task(title: newTaskTitle)
        
        viewModel.tasks.insert(newTask, at: 0)
        newTaskTitle = "" // reseting the value
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
