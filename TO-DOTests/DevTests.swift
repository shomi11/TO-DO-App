//
//  DevTests.swift
//  TO-DOTests
//
//  Created by Milos Malovic on 27.5.21..
//

import CoreData
import XCTest
@testable import TO_DO

class DevTests: BaseTests {

    func testSampleData() throws {
        try dataController.createSampleData()
        XCTAssertEqual( try managedObjectContext.count(for: Project.fetchRequest()), 5, "")
        XCTAssertEqual( try managedObjectContext.count(for: Task.fetchRequest()), 50, "")
    }

    func testDeleteAllClears() throws {
        try dataController.createSampleData()
        dataController.deleteAll()
        XCTAssertEqual( try managedObjectContext.count(for: Project.fetchRequest()), 0, "")
        XCTAssertEqual( try managedObjectContext.count(for: Task.fetchRequest()), 0, "")
    }

    func testExampleTask() {
        let task = Task.example
        XCTAssertTrue(task.priority == 3, "example task priority should be 3")
    }

    func testProjectExample() {
        let project = Project.example
        XCTAssertTrue(project.closed, "example project should be closed")
    }
}
