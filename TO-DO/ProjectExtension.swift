//
//  ProjectExtension.swift
//  TO-DO
//
//  Created by Milos Malovic on 17.5.21..
//

import Foundation


extension Project {
    
    var unwrapedTitle: String {
        title ?? ""
    }
    
    var unwrapedCreationDate: Date {
        creationDate ?? Date()
    }
    
    var unwrapedDetail: String {
        detail ?? ""
    }
    
    var unwrapedColor: String {
        color ?? "red"
    }
    
    var comppletionAmmount: Double {
        let items = tasks?.allObjects as? [Task] ?? []
        guard items.isEmpty == false else { return 0 }
        let completedTasks = items.filter(\.completed)
        return Double(completedTasks.count) / Double(items.count)
    }
    
    var projectTasks: [Task] {
        let allTasks = tasks?.allObjects as? [Task] ?? []
        return allTasks.sorted { first, second in
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
            return first.unwrapedCreationDate < second.unwrapedCreationDate
        }
    }
    
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
