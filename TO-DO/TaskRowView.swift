//
//  TaskRowView.swift
//  TO-DO
//
//  Created by Milos Malovic on 17.5.21..
//

import SwiftUI

struct TaskRowView: View {
    
    @ObservedObject var task: Task
    
    var body: some View {
        NavigationLink(destination: TaskEditingView(task: task)) {
            Text(task.unwrapedTitle)
        }
    }
}

struct TaskRowView_Previews: PreviewProvider {
    static var previews: some View {
        TaskRowView(task: Task.example)
    }
}
