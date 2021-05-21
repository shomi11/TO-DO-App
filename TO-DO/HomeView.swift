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
                    ScrollView(.horizontal, showsIndicators: false) {
                        LazyHGrid(rows: projectRows) {
                            ForEach(projects) {project in
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
                                .accessibility(label: Text("\(project.unwrapedTitle), \(project.projectTasks.count) tasks, \(project.comppletionAmmount * 100, specifier: "%g") percent complete"))
                            }
                        }
                        .padding([.horizontal, .top])
                        .fixedSize(horizontal: false, vertical: true)
                    }
                    
                    VStack(alignment: .leading) {
                        importantTaskList("Up next", for: tasks.wrappedValue.prefix(3))
                        importantTaskList("More task", for: tasks.wrappedValue.dropFirst(3))
                    }
                    .padding(.horizontal)
                }
            }
            .background(Color.groupedSystemBackgroundColor.ignoresSafeArea())
            .navigationTitle("Home")
        }
    }
    
    @ViewBuilder func importantTaskList(_ title: String, for tasks: FetchedResults<Task>.SubSequence) -> some View {
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

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
