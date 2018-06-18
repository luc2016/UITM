//
//  MetaDataTests.swift
//  SearchAppUITests
//
//  Created by Lu Cui (LCL) on 2018-06-05.
//  Copyright © 2018 lcl. All rights reserved.
//

import XCTest

class MetaDataTests: XCTestCase {
    
    func testSetTestID() {
        self.metaData.testID = "Test1"
        XCTAssert(self.metaData.testID == "Test1", "Test id is not set properly." )
    }
    
    func testSetTestComment() {
        self.metaData.comments = "Test comments."
        XCTAssert(self.metaData.comments == "Test comments.", "Test comment is not set properly." )
    }
    
    func testSetFailureMessage() {
        self.metaData.failureMessage = "Test failed."
        XCTAssert(self.metaData.failureMessage == "Test failed.", "Test failure message is not set properly." )
    }
    
}
