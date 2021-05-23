//
//  ProjectEditingView.swift
//  TO-DO
//
//  Created by Milos Malovic on 18.5.21..
//

import SwiftUI

struct ProjectEditingView: View {

    var project: Project
    @EnvironmentObject var dataController: DataController
    @Environment(\.presentationMode) var presentationMode
    @State private var showDeleteConfirmation = false

    @State private var title: String
    @State private var detail: String
    @State private var color: String

    init(project: Project) {
        self.project = project
        _title = State(wrappedValue: project.unwrapedTitle)
        _detail = State(wrappedValue: project.unwrapedDetail)
        _color = State(wrappedValue: project.unwrapedColor)
    }

    let colorColoumns = [GridItem(.adaptive(minimum: 44))]

    var body: some View {
        Form {
            Section(header: Text("Basic settings:")) {
                TextField("Project title", text: $title.onChange(updateEditedProject))
                TextField("Project description:", text: $detail.onChange(updateEditedProject))
            }

            Section(header: Text("Choose project color:")) {
                LazyVGrid(columns: colorColoumns) {
                    ForEach(Project.colors, id: \.self, content: chooseColorBtn)
                }
                .padding(.vertical, 6)
            }

            Section(footer: Text("Closing a project will move project to closed tab, deleting project removes it entirely")) {
                Button(project.closed ? "Reopen project" : "Close project") {
                    project.closed.toggle()
                    updateEditedProject()
                }

                Button("Delete project") {
                    showDeleteConfirmation.toggle()
                }
                .accentColor(Color("Red"))

            }
        }
        .navigationTitle("Edit Project")
        .onDisappear(perform: dataController.save)
        .alert(isPresented: $showDeleteConfirmation) {
            Alert(title: Text("Delete \(project.unwrapedTitle)?"),
                  message: Text("Are you sure?"),
                  primaryButton: .default(Text("Delete"),
                                          action: deleteProject),
                  secondaryButton: .cancel())
        }
    }

    private func updateEditedProject() {
        project.title = title
        project.detail = detail
        project.color = color
    }

    private func deleteProject() {
        dataController.delete(project)
        presentationMode.wrappedValue.dismiss()
    }

    private func chooseColorBtn(for item: String) -> some View {
        ZStack {
            Color(item)
                .aspectRatio(1, contentMode: .fit)
                .cornerRadius(6)

            if color == item {
                Image(systemName: "checkmark.circle")
                    .foregroundColor(.white)
                    .font(.largeTitle)
            }
        }.onTapGesture {
            color = item
            updateEditedProject()
        }
        .accessibilityElement(children: .ignore)
        .accessibilityAddTraits(
            item == color
                ? [.isButton, .isSelected]
            : .isButton
        )
        .accessibilityLabel(item)
    }
}

struct ProjectEditingView_Previews: PreviewProvider {
    static var previews: some View {
        ProjectEditingView(project: Project.example)
    }
}
