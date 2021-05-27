//
//  TO_DOTests.swift
//  TO-DOTests
//
//  Created by Milos Malovic on 27.5.21..
//

import XCTest
import CoreData
@testable import TO_DO

class BaseTests: XCTestCase {

    var dataController: DataController!
    var managedObjectContext: NSManagedObjectContext!

    override func setUpWithError() throws {
        dataController = DataController(inRAMMemoryUsage: true)
        managedObjectContext = dataController.container.viewContext
    }
}
