//
//  DataController.swift
//  TO-DO
//
//  Created by Milos Malovic on 16.5.21..
//

import CoreData
import CoreSpotlight
import SwiftUI

/// Environment singleton class for managing core data stack, saving and deleting, also handling test data.
class DataController: ObservableObject {

    let container: NSPersistentCloudKitContainer

    /// Initialize data controller in memory(for testing and previewing), or on permanent storage for real app usage.
    /// - Parameter inRAMMemoryUsage: boolean store in memory for testing or in permanent storage.
    init(inRAMMemoryUsage: Bool = false) {
        container = NSPersistentCloudKitContainer(name: "Main", managedObjectModel: Self.model)
        if inRAMMemoryUsage {
            container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        }

        container.loadPersistentStores { _, error in
            guard error == nil else {
                fatalError("cant load data, app is dead \(String(describing: error?.localizedDescription))") }
        }

        #if DEBUG
        if CommandLine.arguments.contains("enable-testing") {
            self.deleteAll()
            UIView.setAnimationsEnabled(false)
        }
        #endif

    }

    /// Static property to initialize in preview's for in memory usage.
    static var preview: DataController = {
        let controller = DataController(inRAMMemoryUsage: true)
        do {
            try controller.createSampleData()
        } catch {
            fatalError("fatal error creating preview \(error.localizedDescription)")
        }
        return controller
    }()

    static let model: NSManagedObjectModel = {
        guard let url = Bundle.main.url(forResource: "Main", withExtension: "momd") else {
            fatalError("cant find Main")
        }
        guard let model = NSManagedObjectModel(contentsOf: url) else { fatalError("cant load model") }
        return model
    }()

    /// Creates dummy data items and project for purpose of testing.
    /// - Throws: Throws an NSError witch is called from save() on NSManagedObjectContext.
    func createSampleData() throws {
        let context = container.viewContext
        for ips in 1...5 {
            let project = Project(context: context)
            project.title = "Project \(ips)"
            project.tasks = []
            project.creationDate = Date()
            project.closed = Bool.random()

            for jus in 1...10 {
                let task = Task(context: context)
                task.title = "Task \(jus)"
                task.creationDate = Date()
                task.completed = Bool.random()
                task.project = project
            }
        }
        try context.save()
    }

    /// Saves core data context only if there are changes
    /// if there are not, we really do not need to execute saving on context.
    func save() {
        if container.viewContext.hasChanges {
            try? container.viewContext.save()
        }
    }

    /// Delete any NSManaged object from core data stack and form spot light search.
    /// - Parameter object: object to delete from core data.
    func delete(_ object: NSManagedObject) {
        let objectID = object.objectID.uriRepresentation().absoluteString
        if object is Task {
            CSSearchableIndex.default().deleteSearchableItems(withIdentifiers: [objectID])
        } else {
            CSSearchableIndex.default().deleteSearchableItems(withDomainIdentifiers: [objectID])
        }
        container.viewContext.delete(object)
    }

    /// Delete all managed object's in core data stack.
    func deleteAll() {
        let fetchRequest1: NSFetchRequest<NSFetchRequestResult> = Task.fetchRequest()
        let batchRequest1 = NSBatchDeleteRequest(fetchRequest: fetchRequest1)
        _ = try? container.viewContext.execute(batchRequest1)
        let fetchRequest2: NSFetchRequest<NSFetchRequestResult> = Project.fetchRequest()
        let batchRequest2 = NSBatchDeleteRequest(fetchRequest: fetchRequest2)
        _ = try? container.viewContext.execute(batchRequest2)
    }

    /// Writing task to spot light
    /// - Parameter task: task to be shown in spot light
    func update(_ task: Task) {
        let taskID = task.objectID.uriRepresentation().absoluteString
        let projectID = task.project?.objectID.uriRepresentation().absoluteString
        let attributeSet = CSSearchableItemAttributeSet(contentType: .text)
        attributeSet.title = task.unwrappedTitle
        attributeSet.contentDescription = task.unwrappedDetail
        let searchableItem = CSSearchableItem(
            uniqueIdentifier: taskID,
            domainIdentifier: projectID,
            attributeSet: attributeSet
        )
        CSSearchableIndex.default().indexSearchableItems([searchableItem])
        save()
    }

    func task(with identifier: String) -> Task? {
        guard let url = URL(string: identifier) else { return nil }
        guard let objectID = container.persistentStoreCoordinator.managedObjectID(forURIRepresentation: url) else {
            return nil
        }
        return try? container.viewContext.existingObject(with: objectID) as? Task
    }
}
