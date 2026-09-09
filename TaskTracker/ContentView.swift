import SwiftUI

struct ContentView: View {
    
    @State private var taskCount: Int = 0
    @State private var completedTasksCount: Int = 0
    @State private var newTaskTitle: String = ""
    @State private var tasks: [Task] = [
        Task(title: "Learn Swift"),
        Task(title: "Build an app"),
        Task(title: "Deploy to App Store")
    ]
    @State private var showAddTask: Bool = false
    
    var body: some View {
        NavigationSplitView {
            List(){
                ForEach(tasks) { task in
                    HStack{
                        Button(action: { changeTaskStatus(task: task) }) {
                            Image(systemName: task.isCompleted ? "checkmark.circle.fill" : "circlebadge")
                        }
                        Text(task.title)
                            .strikethrough(task.isCompleted)
                        Spacer() //put the info button to the right
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
            .navigationTitle("Task tracker")
            .navigationBarTitleDisplayMode(.large)
            .navigationSubtitle("\(completedTasksCount) tasks completed.")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {showAddTask = true }) {
                        Label("Add task", systemImage: "plus")
                    }
                    // sheet is a small dialog that pops up from the bottom
                    .sheet(isPresented: $showAddTask) { // $ to both read and write the value
                        VStack(spacing: 20) {
                            Text("Add new task")
                                .font(.title2)
                                .fontWeight(.bold)
                            TextField("Title", text: $newTaskTitle)
                                .textFieldStyle(.roundedBorder)
                            Button(action: {
                                addTask()
                                showAddTask = false
                            }){
                                Text("Add task")
                            }
                            .buttonStyle(.borderedProminent)
                        }
                        .padding()
                        .presentationDetents([.fraction(0.25)])
                    }
                }
            }
        }
        detail: {
            Text("add new task")
        }
    }
    
    private func addTask() {
        let newTask = Task(title: newTaskTitle)
        tasks.append(newTask)
        
        newTaskTitle = "" // reseting the value
    }
    
    private func taskInfo(){
        
    }
    
    private func changeTaskStatus(task: Task) {
        if let index = tasks.firstIndex(where: { $0.id == task.id }) {
            tasks[index].isCompleted.toggle()
            completedTasksCount = tasks.filter { $0.isCompleted }.count
        }
    }
    
    private func deleteTask(task: Task) {
        tasks.removeAll { $0.id == task.id }
    }
}

#Preview {
    ContentView()
}
