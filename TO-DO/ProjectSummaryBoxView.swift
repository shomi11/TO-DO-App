//
//  ProjectSummaryBoxView.swift
//  TO-DO
//
//  Created by Milos Malovic on 21.5.21..
//

import SwiftUI

struct ProjectSummaryBoxView: View {

    @ObservedObject var project: Project

    var body: some View {
        VStack(alignment: .leading) {
            let tasks = project.projectTasks.filter { $0.completed == false }
            Text("\(tasks.count) open tasks")
                .font(.caption)
                .foregroundColor(.secondary)
            Text(project.unwrapedTitle)
                .font(.title2)
            ProgressView(value: project.comppletionAmmount)
                .accentColor(Color(project.unwrapedColor))
        }
        .padding()
        .background(Color.secondarySystemGroupedBackgroundColor)
        .cornerRadius(8)
        .accessibilityElement(children: .combine)
        .accessibility(label: project.accesibilityLbl)
    }
}

struct ProjectSummaryBoxView_Previews: PreviewProvider {
    static var previews: some View {
        ProjectSummaryBoxView(project: Project.example)
    }
}
