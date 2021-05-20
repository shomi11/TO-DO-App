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
            List {
                ForEach(projects.wrappedValue) { project in
                    Section(header: ProjectHeaderView(project: project)) {
                        ForEach(project.projectTasks) { task in
                            TaskRowView(task: task)
                        }
                        .onDelete { offsets in
                            for offset in offsets {
                                let task = project.projectTasks[offset]
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
            }.listStyle(InsetGroupedListStyle())
            .navigationTitle(showClosedProject ? "Closed Projects" : "Open Projects")
            .toolbar {
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
