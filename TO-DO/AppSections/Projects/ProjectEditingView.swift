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
    @State private var shouldRemindMe: Bool
    @State private var remindMe: Date

    init(project: Project) {
        self.project = project
        _title = State(wrappedValue: project.unwrappedTitle)
        _detail = State(wrappedValue: project.unwrappedDetail)
        _color = State(wrappedValue: project.unwrappedColor)
        if let reminder = project.reminder {
            _remindMe = State(wrappedValue: reminder)
            _shouldRemindMe = State(wrappedValue: true)
        } else {
            _remindMe = State(wrappedValue: Date())
            _shouldRemindMe = State(wrappedValue: false)
        }
    }

    let colorColumns = [GridItem(.adaptive(minimum: 44))]

    var body: some View {
        Form {
            Section(header: Text("Basic settings:")) {
                TextField("Project title", text: $title.onChange(updateEditedProject))
                TextField("Project description:", text: $detail.onChange(updateEditedProject))
            }

            Section(header: Text("Choose project color:")) {
                LazyVGrid(columns: colorColumns) {
                    ForEach(Project.colors, id: \.self, content: chooseColorButton)
                }
                .padding(.vertical, 6)
            }

            Section(header: Text("Reminder")) {
                Toggle("Show reminder", isOn: $shouldRemindMe.animation().onChange(updateEditedProject))
                if shouldRemindMe {
                    DatePicker(
                        "Time",
                        selection: $remindMe.onChange(updateEditedProject),
                        displayedComponents: .hourAndMinute
                    )
                }
            }

            // swiftlint:disable:next line_length
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
            Alert(title: Text("Delete \(project.unwrappedTitle)?"),
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
        if shouldRemindMe {
            project.reminder = remindMe
        } else {
            project.reminder = nil
        }
    }

    private func deleteProject() {
        dataController.delete(project)
        presentationMode.wrappedValue.dismiss()
    }

    private func chooseColorButton(for item: String) -> some View {
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
