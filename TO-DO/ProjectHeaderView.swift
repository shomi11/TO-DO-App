//
//  ProjectHeaderView.swift
//  TO-DO
//
//  Created by Milos Malovic on 18.5.21..
//

import SwiftUI

struct ProjectHeaderView: View {

    @ObservedObject var project: Project

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(project.unwrapedTitle)
                ProgressView(value: project.comppletionAmmount)
                    .accentColor(Color(project.unwrapedColor))
            }
            Spacer()

            NavigationLink(destination: ProjectEditingView(project: project)) {
                Image(systemName: "square.and.pencil")
                    .imageScale(.large)
            }
        }
        .padding(.bottom, 8)
        .accessibilityElement(children: .combine)
    }
}

struct ProjectHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        ProjectHeaderView(project: Project.example)
    }
}
