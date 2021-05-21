//
//  HomeView.swift
//  TO-DO
//
//  Created by Milos Malovic on 17.5.21..
//

import SwiftUI
import CoreData

struct HomeView: View {
   
    static let tag: String? = "HomeView"

    @EnvironmentObject var dataController: DataController
    @FetchRequest(entity: Project.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Project.closed, ascending: true), NSSortDescriptor(keyPath: \Project.creationDate, ascending: true)] , predicate: NSPredicate(format: "closed = false"))
    
    var projects: FetchedResults<Project>
    var tasks: FetchRequest<Task>
    
    var projectRows: [GridItem] {
        [GridItem(.adaptive(minimum: 120, maximum: 120))]
    }
    
    init() {
        let taskRequest: NSFetchRequest<Task> = Task.fetchRequest()
        taskRequest.predicate = NSPredicate(format: "completed = false")
        taskRequest.sortDescriptors = [NSSortDescriptor(keyPath: \Task.priority, ascending: false)]
        taskRequest.fetchLimit = 8
        tasks = FetchRequest(fetchRequest: taskRequest)
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading) {
                    topProjectHorizntalView
                    VStack(alignment: .leading) {
                        TaskSubsequenceView(title: "Next Task", tasks: tasks.wrappedValue.prefix(3))
                        TaskSubsequenceView(title: "More", tasks: tasks.wrappedValue.dropFirst(3))
                    }
                    .padding(.horizontal)
                }
            }
            .background(Color.groupedSystemBackgroundColor.ignoresSafeArea())
            .navigationTitle("Home")
        }
    }
}

extension HomeView {
    var topProjectHorizntalView: some View {
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
