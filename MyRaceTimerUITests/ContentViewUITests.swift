//
//  ContentViewUITests.swift
//  MyRaceTimerUITests
//
//  Created by niko dittmar on 4/28/23.
//

import Foundation
import XCTest

class ContentViewTests: XCTestCase {
    var app: XCUIApplication!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        app = XCUIApplication()
        app.launchArguments = ["forTesting"]
        app.launch()
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
        app.terminate()
    }

    func testRecordTimeButton() throws {
        let recordTimeButton = app.buttons["Record Time"]
        let recordingsList = app.collectionViews["Recordings"]
        let recordings = recordingsList.descendants(matching: .button)

        XCTAssertTrue(recordTimeButton.exists)
        XCTAssertTrue(recordingsList.exists)
        XCTAssertEqual(recordings.count, 0)
        recordTimeButton.tap()
        XCTAssertEqual(recordings.count, 1)
        recordTimeButton.tap()
        recordTimeButton.tap()
        XCTAssertEqual(recordings.count, 3)
    }
}
