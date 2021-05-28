//
//  TaskExtension.swift
//  TO-DO
//
//  Created by Milos Malovic on 17.5.21..
//

import Foundation

/// Core data Task object extension
/// Handling optionals in core data, managing some dummy data for preview's.
extension Task {

    enum SortOrder {
        case title, `default`, creationDate
    }

    var unwrappedTitle: String {
        title ?? "New Task"
    }

    var unwrappedCreationDate: Date {
        creationDate ?? Date()
    }

    var unwrappedPriority: Int {
        Int(priority)
    }

    var unwrappedDetail: String {
        detail ?? ""
    }

    /// Task example for preview usage.
    static var example: Task {
        let controller = DataController.preview
        let context = controller.container.viewContext
        let task = Task(context: context)
        task.title = "Example task"
        task.creationDate = Date()
        task.detail = "This is example detail task"
        task.priority = 3
        return task
    }
}
