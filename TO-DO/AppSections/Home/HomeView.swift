//
//  HomeView.swift
//  TO-DO
//
//  Created by Milos Malovic on 17.5.21..
//

import SwiftUI
import CoreData
import CoreSpotlight

struct HomeView: View {

    static let tag: String? = "HomeView"

    @EnvironmentObject var dataController: DataController

    @FetchRequest(entity: Project.entity(),
                  sortDescriptors: [NSSortDescriptor(keyPath: \Project.creationDate, ascending: true)],
                  predicate: NSPredicate(format: "closed = false"))

    var projects: FetchedResults<Project>
    var tasks: FetchRequest<Task>

    @State var spotlightSelectedTask: Task?

    var projectRows: [GridItem] {
        [GridItem(.adaptive(minimum: 120, maximum: 120))]
    }

    /// Initialize view Fetch request fetching tasks with limit of 8, only open tasks
    /// from only open projects and top priority task first.
    init() {
        let taskRequest: NSFetchRequest<Task> = Task.fetchRequest()
        let taskClosedPredicate = NSPredicate(format: "completed = false")
        let projectClosedPredicate = NSPredicate(format: "project.closed = false")
        /// Compound predicate combines several NSPredicate's.
        let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates:
                                                        [taskClosedPredicate, projectClosedPredicate])
        taskRequest.predicate = compoundPredicate
        taskRequest.sortDescriptors = [NSSortDescriptor(keyPath: \Task.priority, ascending: false)]
        taskRequest.fetchLimit = 8
        tasks = FetchRequest(fetchRequest: taskRequest)
    }

    var body: some View {
        NavigationView {
            ScrollView {
                if let spotlightTask = spotlightSelectedTask {
                    NavigationLink(
                        destination: TaskEditingView(task: spotlightTask),
                        tag: spotlightTask,
                        selection: $spotlightSelectedTask,
                        label: EmptyView.init
                    )
                    .id(spotlightTask)
                }
                VStack(alignment: .leading) {
                    topProjectHorizontalView
                    VStack(alignment: .leading) {
                        TaskSubsequenceView(title: "Next Task", tasks: tasks.wrappedValue.prefix(3))
                        TaskSubsequenceView(title: "More", tasks: tasks.wrappedValue.dropFirst(3))
                    }
                    .padding(.horizontal)
                }
            }
            .background(Color.groupedSystemBackgroundColor.ignoresSafeArea())
            .navigationTitle("Home")
        }.onContinueUserActivity(CSSearchableItemActionType, perform: loadSpotLightItem)
    }

    func selectTask(with identifier: String) {
        spotlightSelectedTask = dataController.task(with: identifier)
    }

    func loadSpotLightItem(_ userActivity: NSUserActivity) {
        if let identifier = userActivity.userInfo?[CSSearchableItemActivityIdentifier] as? String {
            selectTask(with: identifier)
        }
    }
}

extension HomeView {
    var topProjectHorizontalView: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHGrid(rows: projectRows) {
                ForEach(projects, content: ProjectSummaryBoxView.init)
            }
            .padding([.horizontal, .top])
            .fixedSize(horizontal: false, vertical: true)
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
