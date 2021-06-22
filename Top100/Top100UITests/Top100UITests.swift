//
//  Top100UITests.swift
//  Top100UITests
//
//  Created by Manpreet on 27/10/2020.
//

import XCTest

class Top100UITests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testNavigationBar() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()
        let navTitleIdentifier = "Top 100"
        let navigationTitleElement = app.navigationBars.matching(identifier: navTitleIdentifier).firstMatch
        XCTAssert(navigationTitleElement.exists)
    }
    
    func testTableViewCells() throws {
        let app = XCUIApplication()
        app.launch()
        let tableView = app.tables.containing(.table, identifier: "AlbumTable")
        let expectation = self.expectation(description: "Wait for stubbed response")
        let result = XCTWaiter.wait(for: [expectation], timeout: 5.0)
         if result == XCTWaiter.Result.timedOut {
            XCTAssertTrue(tableView.cells.count > 0)
            let firstCell = tableView.cells.element(boundBy: 0)
            firstCell.tap()
            expectation.fulfill()
         } else {
             XCTFail("Delay interrupted")
         }
    }

    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}
