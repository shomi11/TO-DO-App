//
//  TaskEditingView.swift
//  TO-DO
//
//  Created by Milos Malovic on 17.5.21..
//

import SwiftUI

struct TaskEditingView: View {
    
    let task: Task
    
    @EnvironmentObject var dataController: DataController
    
    @State private var title: String
    @State private var detail: String
    @State private var completed: Bool
    @State private var priority: Int
    
    init(task: Task) {
        self.task = task
        _title = State(wrappedValue: task.unwrapedTitle)
        _detail = State(wrappedValue: task.unwrapedDetail)
        _completed = State(wrappedValue: task.completed)
        _priority = State(wrappedValue: task.unwrapedPriority)
    }
    
    var body: some View {
        Form {
            Section(header: Text("Settings")) {
                TextField("Item name", text: $title.onChange(saveEditedTask))
                TextField("Description", text: $detail.onChange(saveEditedTask))
            }
            Section(header: Text("Select priority")) {
                Picker("Priority", selection: $priority.onChange(saveEditedTask)) {
                    Text("Low").tag(1)
                    Text("Medium").tag(2)
                    Text("High").tag(3)
                }.pickerStyle(SegmentedPickerStyle())
            }
            Section {
                Toggle("Mark completed", isOn: $completed.onChange(saveEditedTask))
            }
        }.navigationTitle("Edit Task")
        .onDisappear(perform: dataController.save)
    }
    
    private func saveEditedTask() {
        task.project?.objectWillChange.send()
        task.title = title
        task.detail = detail
        task.priority = Int16(priority)
        task.completed = completed
    }
}

struct TaskEditingView_Previews: PreviewProvider {
    static var previews: some View {
        TaskEditingView(task: Task.example)
    }
}
