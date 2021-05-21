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
    
    var body: some View {
        NavigationLink(destination: TaskEditingView(task: task)) {
            Label {
                Text(task.unwrapedTitle)
            } icon: {
                icon
            }
        }
        .accessibilityLabel(accesibilitiLbl)
    }
}

private extension TaskRowView {
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
    
    var accesibilitiLbl: Text {
        if task.completed {
            return Text("\(task.unwrapedTitle) completed.")
        } else if task.priority == 3 {
            return Text("\(task.unwrapedTitle) is high priority.")
        } else if task.priority == 2 {
            return Text("\(task.unwrapedTitle) is medium priority.")
        } else {
            return Text("\(task.unwrapedTitle)")
        }
    }
}

struct TaskRowView_Previews: PreviewProvider {
    static var previews: some View {
        TaskRowView(project: Project.example, task: Task.example)
    }
}
