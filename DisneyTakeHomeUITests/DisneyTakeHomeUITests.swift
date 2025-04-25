//
//  DisneyTakeHomeUITests.swift
//  DisneyTakeHomeUITests
//
//  Created by Oliver Paray on 4/24/25.
//

import XCTest

final class DisneyTakeHomeUITests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    @MainActor
    func testSearch() throws {
        let app = XCUIApplication()
        app.launch()
        let launchScreenshot = XCUIScreen.main.screenshot()
        let launchAttachment = XCTAttachment(screenshot: launchScreenshot)
        launchAttachment.lifetime = .keepAlways
        add(launchAttachment)
        
        let textField = app.textFields["search_text_field"]
        _ = textField.waitForExistence(timeout: 5)
        textField.tap()
        textField.typeText("rahxephon")
        let searchScreenShot = XCUIScreen.main.screenshot()
        let searchAttachment = XCTAttachment(screenshot: searchScreenShot)
        searchAttachment.lifetime = .keepAlways
        add(searchAttachment)
        
        let resultsList = app.tables["results_list"]
        _ = resultsList.waitForExistence(timeout: 10)
        let resultsScreenShot = XCUIScreen.main.screenshot()
        let resultsAttachment = XCTAttachment(screenshot: resultsScreenShot)
        resultsAttachment.lifetime = .keepAlways
        add(resultsAttachment)
    }

    @MainActor
    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}
