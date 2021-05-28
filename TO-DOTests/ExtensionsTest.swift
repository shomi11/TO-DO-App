//
//  ExtensionsTest.swift
//  TO-DOTests
//
//  Created by Milos Malovic on 28.5.21..
//

import SwiftUI
import XCTest
@testable import TO_DO

class ExtensionsTest: XCTestCase {

    func testOnChangeBinding() {
        // This value here is just to check is functionToCall run
        var onChangeFuncRun = false

        // Nested function to change value of onChangeFuncRun variable
        func functionToCall() {
            onChangeFuncRun = true
        }

        // Variable to read and write in binding
        var test = ""

        let binding = Binding(
            get: { test },
            set: { test = $0 }
        )

        // Whenever binding is changed it will call functionToCall() and modify onChangeFuncRun variable
        let changedBinding = binding.onChange { functionToCall() }

        // Taking original binding and changing it
        changedBinding.wrappedValue = "ABC"

        XCTAssertTrue(onChangeFuncRun, "functionToCall() should be run and onChangeFuncRun should be true.")
    }
}
