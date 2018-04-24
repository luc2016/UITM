//
//  UITMTests.swift
//  UITMTests
//
//  Created by Lu Cui (LCL) on 2018-04-18.
//  Copyright © 2018 lcl. All rights reserved.
//

import XCTest
import Alamofire
import Alamofire_Synchronous

class UITMTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testMetaData() {
        self.metaData = "GOLM-T1"
        XCTAssert(self.metaData == "GOLM-T1")
    }
    
    
}
