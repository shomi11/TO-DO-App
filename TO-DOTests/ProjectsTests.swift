//
//  ProjectsTests.swift
//  TO-DOTests
//
//  Created by Milos Malovic on 27.5.21..
//

import CoreData
import XCTest
@testable import TO_DO

class ProjectsTests: BaseTests {

    /// Delete project should delete all of its items
    /// - Throws: marked as throwing just because createSampleData is throwing
    func testDeleteProjectWithAllItsTasks() throws {
        // This will create 10 projects with 10 tasks inside each
        try dataController.createSampleData()

        let request = NSFetchRequest<Project>(entityName: "Project")
        let projects = try managedObjectContext.fetch(request)

        // Delete first project in list
        dataController.delete(projects[0])

        // Should be 4 project with 10 items inside of each
        XCTAssertEqual(try managedObjectContext.count(for: Project.fetchRequest()), 4)
        XCTAssertEqual(try managedObjectContext.count(for: Task.fetchRequest()), 40)
    }
}
