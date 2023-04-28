//
//  DataControllerTests.swift
//  MyRaceTimerTests
//
//  Created by niko dittmar on 4/26/23.
//

import XCTest
@testable import MyRaceTimer

@MainActor class DataControllerTests: XCTestCase {
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testCreateRecordingSet() {
        let dataController: DataController = DataController(forTesting: true)
        
        let recordingSetCount = dataController.getRecordingSets().count
        
        dataController.createRecordingSet()
        
        XCTAssertGreaterThan(dataController.getRecordingSets().count, recordingSetCount)
    }
    
    func testGetSelectedRecordingSet() {
        let dataController: DataController = DataController(forTesting: true)
        
        XCTAssertNil(dataController.selectedRecordingSet)
        
        
    }
}

