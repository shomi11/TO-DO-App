//
//  TaskExtension.swift
//  TO-DO
//
//  Created by Milos Malovic on 17.5.21..
//

import Foundation


extension Task {
    
    var unwrapedTitle: String {
        title ?? ""
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
}
