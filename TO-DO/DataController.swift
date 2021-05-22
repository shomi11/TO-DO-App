//
//  DataController.swift
//  TO-DO
//
//  Created by Milos Malovic on 16.5.21..
//

import Foundation
import CoreData
import SwiftUI

class DataController: ObservableObject {

    let container: NSPersistentCloudKitContainer

    init(inRAMMemoryUsage: Bool = false) {
        container = NSPersistentCloudKitContainer(name: "Main")
        if inRAMMemoryUsage {
            container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        }

        container.loadPersistentStores { _, error in
            guard error == nil else {
                fatalError("cant load data, app is dead \(String(describing: error?.localizedDescription))") }
        }
    }

    static var preview: DataController = {
        let controller = DataController(inRAMMemoryUsage: true)
        do {
            try controller.createSampleData()
        } catch {
            fatalError("fatal error creating preview \(error.localizedDescription)")
        }
        return controller
    }()

    func createSampleData() throws {
        let context = container.viewContext
        for ips in 1...5 {
            let project = Project(context: context)
            project.title = "Project \(ips)"
            project.tasks = []
            project.creationDate = Date()
            project.closed = Bool.random()

            for jks in 1...10 {
                let taks = Task(context: context)
                taks.title = "Task \(jks)"
                taks.creationDate = Date()
                taks.completed = Bool.random()
                taks.project = project
            }
        }
        try context.save()
    }

    func save() {
        if container.viewContext.hasChanges {
            try? container.viewContext.save()
        }
    }

    func delete(_ object: NSManagedObject) {
        container.viewContext.delete(object)
    }

    func deleteAll() {
        let fetchRequest1: NSFetchRequest<NSFetchRequestResult> = Task.fetchRequest()
        let batchRequest1 = NSBatchDeleteRequest(fetchRequest: fetchRequest1)
        _ = try? container.viewContext.execute(batchRequest1)
        let fetchRequest2: NSFetchRequest<NSFetchRequestResult> = Project.fetchRequest()
        let batchRequest2 = NSBatchDeleteRequest(fetchRequest: fetchRequest2)
        _ = try? container.viewContext.execute(batchRequest2)
    }
}
