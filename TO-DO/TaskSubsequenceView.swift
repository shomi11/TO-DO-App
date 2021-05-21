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
            ForEach(tasks) { task in
                NavigationLink(destination: TaskEditingView(task: task)) {
                    HStack(spacing: 16) {
                        Circle()
                            .stroke(Color(task.project?.unwrapedColor ?? "Light Blue"), lineWidth: 3)
                            .frame(width: 10, height: 10)
                        VStack(alignment: .leading) {
                            Text(task.unwrapedTitle)
                                .font(.body)
                                .foregroundColor(.primary)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            
                            if !task.unwrapedDetail.isEmpty {
                                Text(task.unwrapedDetail)
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                    .padding()
                    .background(Color.secondarySystemGroupedBackgroundColor)
                    .cornerRadius(8)
                }
            }
        }
    }
}
