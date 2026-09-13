import SwiftUI

struct TaskInfoView: View {
    
    @Binding var infoTask: Task
    @FocusState private var isFocused: Bool
    @State private var showEditTask: Bool = false
    
    var body: some View {
        NavigationStack {
            VStack {
                Form {
                    Section {
                        TextField("Title", text: $infoTask.title)
                    }
                }
            }
            .navigationTitle("Task info")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button(action: { showEditTask = true }) {
                        Text("Edit")
                    }
                    .sheet(isPresented: $showEditTask) { // selected refers to the $selectedTask value, its a new variable.
                        NavigationStack {
                            VStack {
                                Form {
                                    Section {
                                        TextField("Title", text: $infoTask.title)
                                            .focused($isFocused)
                                    }
                                }
                            }
                            .navigationTitle("Edit task")
                            .navigationBarTitleDisplayMode(.inline)
                            .toolbar {
                                ToolbarItem(placement: .topBarLeading) {
                                    Button(action: { showEditTask = false }) {
                                        Image(systemName: "multiply")
                                    }
                                }
                                ToolbarItem(placement: .confirmationAction) {
                                    Button(action: {
                                        isFocused = true
                                    }) {
                                        Image(systemName: "checkmark")
                                    }
                                }
                            }
                        }
                        .presentationDetents([.fraction(0.99)])
                    }
                }
            }
        }
    }
}
