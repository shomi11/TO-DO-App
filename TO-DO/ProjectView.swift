//
//  ProjectView.swift
//  TO-DO
//
//  Created by Milos Malovic on 17.5.21..
//

import SwiftUI

struct ProjectView: View {
    
    static let openTag: String? = "OpenProjectView"
    static let closeTag: String? = "ClosedProjectsView"
    
    @EnvironmentObject var dataController: DataController
    @Environment(\.managedObjectContext) var manageObjectContext
    @State private var showingSortOrder: Bool = false
    @State private var sortOrder = Task.SortOrder.default
    
    let showClosedProject: Bool
    let projects: FetchRequest<Project>
    
    init(showClosedProject: Bool) {
        self.showClosedProject = showClosedProject
        projects = FetchRequest<Project>(entity: Project.entity(), sortDescriptors: [
            NSSortDescriptor(keyPath: \Project.creationDate, ascending: false)
        ], predicate: NSPredicate(format: "closed = %d", showClosedProject))
        
    }
    
    var body: some View {
        NavigationView {
            Group {
                if projects.wrappedValue.isEmpty {
                    Text("Start a new project")
                } else {
                    List {
                        ForEach(projects.wrappedValue) { project in
                            Section(header: ProjectHeaderView(project: project)) {
                                ForEach(project.projectTasks(using: sortOrder)) { task in
                                    TaskRowView(project: project, task: task)
                                }
                                .onDelete { offsets in
                                    for offset in offsets {
                                        let task = project.projectTasks(using: sortOrder)[offset]
                                        dataController.delete(task)
                                    }
                                    dataController.save()
                                }
                                if showClosedProject == false {
                                    Button {
                                        withAnimation {
                                            let task = Task(context: manageObjectContext)
                                            task.project = project
                                            task.creationDate = Date()
                                            dataController.save()
                                        }
                                    } label: {
                                        Label("Add new task", systemImage: "plus")
                                    }
                                }
                            }
                        }
                    }
                    .listStyle(InsetGroupedListStyle())
                }
            }
            .navigationTitle(showClosedProject ? "Closed Projects" : "Open Projects")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    if showClosedProject == false {
                        Button {
                            withAnimation {
                                let project = Project(context: manageObjectContext)
                                project.closed = false
                                project.creationDate = Date()
                                dataController.save()
                            }
                        } label: {
                            Label("Add Project", systemImage: "plus")
                        }
                    }
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    if showClosedProject == false {
                        Button {
                            showingSortOrder.toggle()
                        } label: {
                            Label("Sort", systemImage: "arrow.up.arrow.down")
                                .accessibilityLabel(Text("Add new project"))
                        }
                    }
                }
            }
            .actionSheet(isPresented: $showingSortOrder) {
                ActionSheet(title: Text("Sort Tasks"), message: nil, buttons: [
                    .default(Text("Default")) { sortOrder = .default },
                    .default(Text("Creation date")) { sortOrder = .creationDate },
                    .default(Text("Title")) { sortOrder = .title },
                    .cancel()
                ])
            }
            CustomEmptyView()
        }
    }
}

struct ProjectView_Previews: PreviewProvider {
    
    static var dataController = DataController.preview
    
    static var previews: some View {
        ProjectView(showClosedProject: false)
            .environment(\.managedObjectContext, dataController.container.viewContext)
            .environmentObject(dataController)
    }
}
