//
//  TaskRowView.swift
//  TO-DO
//
//  Created by Milos Malovic on 17.5.21..
//

import SwiftUI

struct TaskRowView: View {
    
    @ObservedObject var project: Project
    @ObservedObject var task: Task
    
    var icon: some View {
        if task.completed {
            return Image(systemName: "checkmark.circle")
                .foregroundColor(Color(task.project?.color ?? "Light Blue"))
        } else if task.priority == 3 {
            return Image(systemName: "exclamationmark.triangle")
                .foregroundColor(.red)
        } else if task.priority == 2 {
            return Image(systemName: "exclamationmark.triangle")
                .foregroundColor(.yellow)
        } else {
            return Image(systemName: "checkmark.circle")
                .foregroundColor(.clear)
        }
    }
    
    var body: some View {
        NavigationLink(destination: TaskEditingView(task: task)) {
            Label {
                Text(task.unwrapedTitle)
            } icon: {
                icon
            }
        }
    }
}

struct TaskRowView_Previews: PreviewProvider {
    static var previews: some View {
        TaskRowView(project: Project.example, task: Task.example)
    }
}
