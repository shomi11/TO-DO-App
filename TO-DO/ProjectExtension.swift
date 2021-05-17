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
    
    var projectTasks: [Task] {
        tasks?.allObjects as? [Task] ?? []
    }

}
