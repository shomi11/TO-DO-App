//
//  TO_DOUITests.swift
//  TO-DOUITests
//
//  Created by Milos Malovic on 28.5.21..
//

import XCTest

class TODOUITests: XCTestCase {

    var app: XCUIApplication!

    override func setUpWithError() throws {
        // UI tests must launch the application that they test.
        app = XCUIApplication()
        app.launchArguments = ["enable-testing"]
        app.launch()

        continueAfterFailure = false
    }

    func testAppHas3Tabs() throws {

        XCTAssertEqual(app.tabBars.buttons.count, 3, "Should be 3 tab bar buttons")
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testIsOpenTabAddingProject() {
        app.buttons["Open"].tap()
        XCTAssertEqual(app.tables.cells.count, 0, "0 cells should be before plus button tapped.")

        for taps in 1...3 {
            app.buttons["add"].tap()
            XCTAssertEqual(app.tables.cells.count, taps, "\(taps) cells should be after plus button tapped.")
        }
    }

    func testInsertTaskRows() {
        app.buttons["Open"].tap()
        XCTAssertEqual(app.tables.cells.count, 0, "0 cells should be before plus button tapped.")
        app.buttons["add"].tap()
        XCTAssertEqual(app.tables.cells.count, 1, "1 cells should be after plus button tapped.")
        app.buttons["Add new task"].tap()
        XCTAssertEqual(app.tables.cells.count, 2, "1 cells should be after plus button tapped.")
    }

    func testEditinProjectIsCorect() {
        app.buttons["Open"].tap()
        XCTAssertEqual(app.tables.cells.count, 0, "0 cells should be before plus button tapped.")
        app.buttons["add"].tap()
        XCTAssertEqual(app.tables.cells.count, 1, "1 cells should be after plus button tapped.")
        app.buttons["NEW PROJECT"].tap()
        app.textFields["Project title"].tap()

        app.keys["space"].tap()
        app.keys["more"].tap()

        app.keys["2"].tap()
        app.buttons["Return"].tap()

        app.buttons["Open Projects"].tap()
        XCTAssert(app.buttons["NEW PROJECT 2"].exists, "New project 2 should exists")
    }
}
