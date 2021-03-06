//
//  ProjectView.swift
//  TO-DO
//
//  Created by Milos Malovic on 17.5.21..
//

import SwiftUI

struct ProjectView: View {

    // MARK: - EnvironmentObject's
    @EnvironmentObject var dataController: DataController
    @Environment(\.managedObjectContext) var manageObjectContext

    // MARK: - Properties
    static let openTag: String? = "OpenProjectView"
    static let closeTag: String? = "ClosedProjectsView"

    @State private var showingSortOrder: Bool = false
    @State private var sortOrder = Task.SortOrder.default

    let showClosedProject: Bool
    let projects: FetchRequest<Project>

    // MARK: - View Initializer
    /// Initialize project view with project fetch request inside initializer.
    /// - Parameter showClosedProject: use inside initializer for telling view should we show
    /// closed project view or open project view by setting value in predicate parameter for fetch request.
    init(showClosedProject: Bool) {
        self.showClosedProject = showClosedProject
        projects = FetchRequest<Project>(entity: Project.entity(), sortDescriptors: [
            NSSortDescriptor(keyPath: \Project.creationDate, ascending: false)
        ], predicate: NSPredicate(format: "closed = %d", showClosedProject))
    }

    // MARK: - BODY
    var body: some View {
        NavigationView {
            Group {
                if projects.wrappedValue.isEmpty {
                    Text("Start a new project")
                } else {
                    projectList
                }
            }
            .navigationTitle(showClosedProject ? "Closed Projects" : "Open Projects")
            .toolbar {
                addProjectToolBarItem
                sortOrderToolBarItem
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

    // MARK: - struct method's

    /// Automatically add's new project in out core data stack with default values.
    func addNewProject() {
        withAnimation {
            let project = Project(context: manageObjectContext)
            project.closed = false
            project.creationDate = Date()
            dataController.save()
        }
    }

    /// Add new task to core data stack for selected project.
    /// - Parameter project: Project which will contain added task.
    func addNewTask(to project: Project) {
        withAnimation {
            let task = Task(context: manageObjectContext)
            task.project = project
            task.creationDate = Date()
            dataController.save()
        }
    }

    /// On swipe deleting task
    /// - Parameters:
    ///   - offsets: Task position in list, which task will be deleted.
    ///   - project: Project that this task.
    func deleteTask(_ offsets: IndexSet, project: Project) {
        for offset in offsets {
            let task = project.projectTasks(using: sortOrder)[offset]
            dataController.delete(task)
        }
        dataController.save()
    }
}

// MARK: - Body view extension
fileprivate extension ProjectView {

    /// List of project in horizontal scroll, placed bellow navigation bar.
    var projectList: some View {
        List {
            ForEach(projects.wrappedValue) { project in
                Section(header: ProjectHeaderView(project: project)) {
                    ForEach(project.projectTasks(using: sortOrder)) { task in
                        TaskRowView(project: project, task: task)
                    }
                    .onDelete { offsets in
                        deleteTask(offsets, project: project)
                    }
                    if showClosedProject == false {
                        Button {
                           addNewTask(to: project)
                        } label: {
                            Label("Add new task", systemImage: "plus")
                                .accessibilityLabel(Text("Add new task"))
                        }
                    }
                }
            }
        }
        .listStyle(InsetGroupedListStyle())
    }

    /// Placing add button in tool bar only if open project tab is open.
    var addProjectToolBarItem: some ToolbarContent {
        ToolbarItem(placement: .navigationBarTrailing) {
            if showClosedProject == false {
                Button {
                    addNewProject()
                } label: {
                    Label("Add Project", systemImage: "plus")
                        .accessibilityLabel(Text("Add new project"))
                }
            }
        }
    }

    /// Sort button for sorting only open project's.
    var sortOrderToolBarItem: some ToolbarContent {
        ToolbarItem(placement: .navigationBarLeading) {
            if showClosedProject == false {
                Button {
                    showingSortOrder.toggle()
                } label: {
                    Label("Sort", systemImage: "arrow.up.arrow.down")
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
