//
//  TaskExtension.swift
//  TO-DO
//
//  Created by Milos Malovic on 17.5.21..
//

import Foundation


extension Task {
    
    var unwrapedTitle: String {
        title ?? "New Task"
    }
    
    var unwrapedCreationDate: Date {
        creationDate ?? Date()
    }
    
    var unwrapedPriority: Int {
        Int(priority)
    }
    
    var unwrapedDetail: String {
        detail ?? ""
    }
    
    static var example: Task {
       let contoller = DataController(inRAMMemoryUsage: true)
        let context = contoller.container.viewContext
        let task = Task(context: context)
        task.title = "Example task"
        task.creationDate = Date()
        task.detail = "This is example detail task"
        task.priority = 3
        return task
    }
}
