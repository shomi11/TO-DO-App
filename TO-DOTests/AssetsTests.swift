//
//  AssetsTests.swift
//  TO-DOTests
//
//  Created by Milos Malovic on 27.5.21..
//

import XCTest
@testable import TO_DO

class AssetsTests: XCTestCase {

    func testColorsExists() {
        for color in Project.colors {
            XCTAssertNotNil(UIColor(named: color), "\(color) does not exist")
        }
    }

}
