//
//  TaskSubsequenceView.swift
//  TO-DO
//
//  Created by Milos Malovic on 21.5.21..
//

import SwiftUI

struct TaskSubsequenceView: View {

    let title: String
    let tasks: FetchedResults<Task>.SubSequence

    var body: some View {
        if tasks.isEmpty {
            EmptyView()
        } else {
            Text(title)
                .font(.headline)
                .foregroundColor(.secondary)
                .padding(.top)
            ForEach(tasks, content: taskRowView)
        }
    }
}

private extension TaskSubsequenceView {
    func taskRowView(for task: Task) -> some View {
        NavigationLink(destination: TaskEditingView(task: task)) {
            HStack(spacing: 16) {
                Circle()
                    .stroke(Color(task.project?.unwrappedColor ?? "Light Blue"), lineWidth: 3)
                    .frame(width: 10, height: 10)
                VStack(alignment: .leading) {
                    Text(task.unwrappedTitle)
                        .font(.body)
                        .foregroundColor(.primary)
                        .frame(maxWidth: .infinity, alignment: .leading)

                    if !task.unwrappedDetail.isEmpty {
                        Text(task.unwrappedDetail)
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
            }
        }
        .padding()
        .background(Color.secondarySystemGroupedBackgroundColor)
        .cornerRadius(8)
    }
}
