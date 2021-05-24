//
//  ProjectExtension.swift
//  TO-DO
//
//  Created by Milos Malovic on 17.5.21..
//

import SwiftUI

/// Project object extension for handling core data optionals, sorting projects and creating dummy project for previews.
extension Project {

    static let colors = ["Pink",
                         "Purple",
                         "Red",
                         "Orange",
                         "Gold",
                         "Green",
                         "Teal",
                         "Light Blue",
                         "Dark Blue",
                         "Midnight",
                         "Dark Gray",
                         "Gray"
    ]

    var unwrappedTitle: String {
        title ?? "New Project"
    }

    var unwrappedCreationDate: Date {
        creationDate ?? Date()
    }

    var unwrappedDetail: String {
        detail ?? ""
    }

    var unwrappedColor: String {
        color ?? "Light Blue"
    }

    var completionAmount: Double {
        let items = tasks?.allObjects as? [Task] ?? []
        guard items.isEmpty == false else { return 0 }
        let completedTasks = items.filter(\.completed)
        return Double(completedTasks.count) / Double(items.count)
    }

    var amountOfFinishedUserTaks: Double {
        return completionAmount * 100
    }

    var accessibilityCustomLabel: Text {
        // swiftlint:disable:next line_length
        return Text("\(unwrappedTitle), \(projectTasks.count) tasks, \(amountOfFinishedUserTaks, specifier: "%g") percent complete") //
    }

    var projectTasks: [Task] {
        tasks?.allObjects as? [Task] ?? []
    }


    /// Sorting project tasks by user wishes.
    /// - Parameter sortOrder: use SortOrder enum for sorting tasks
    /// - Returns: array of tasks for current selected project, sorted by user choice.
    func projectTasks(using sortOrder: Task.SortOrder) -> [Task] {
        switch sortOrder {
        case .title:
            return projectTasks.sorted { $0.unwrappedTitle < $1.unwrappedTitle }
        case .creationDate:
            return projectTasks.sorted { $0.unwrappedCreationDate < $1.unwrappedCreationDate }
        case .default:
            return projectTasksDefaultSorted
        }
    }

    /// Returns default sorted array of tasks for selected project.
    var projectTasksDefaultSorted: [Task] {
        return projectTasks.sorted { first, second in
            if first.completed == false {
                if second.completed == true {
                    return true
                }
            } else if first.completed == true {
                if second.completed == false {
                    return false
                }
            }
            if first.priority > second.priority {
                return true
            } else if first.priority < second.priority {
                return false
            }
            return first.unwrappedCreationDate < second.unwrappedCreationDate
        }
    }

    /// Project example for previews.
    static var example: Project {
        let controller = DataController(inRAMMemoryUsage: true)
        let context = controller.container.viewContext
        let project = Project(context: context)
        project.title = "Example project"
        project.creationDate = Date()
        project.detail = "This is project example detail"
        project.closed = true
        return project
    }
}
