//
//  MetaDataTests.swift
//  SearchAppUITests
//
//  Created by Lu Cui (LCL) on 2018-06-05.
//  Copyright © 2018 lcl. All rights reserved.
//

import XCTest

class MetaDataTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testSetTestID() {
        self.metaData.testID = "Test1"
        XCTAssert(self.metaData.testID == "Test1", "Test id is not set properly." )
    }
    
    func testSetTestComment() {
        self.metaData.comments = "Test comments."
        XCTAssert(self.metaData.comments == "Test comments.", "Test comment is not set properly." )
    }
    
}
