//
//  TMObserverTests.swift
//  UITMTests
//
//  Created by Lu Cui (LCL) on 2018-05-02.
//  Copyright © 2018 lcl. All rights reserved.
//

//
//  TMObserverTests.swift
//  UITMTests
//
//  Created by Lu Cui (LCL) on 2018-04-24.
//  Copyright © 2018 lcl. All rights reserved.
//

import XCTest

class TestObserver2: TMObserver {
    
    var finishedTestCaseNames = [String]()

    override func testCaseDidFinish(_ testCase: XCTestCase) {
        super.testCaseDidFinish(testCase)
        let testName = testCase.name
        finishedTestCaseNames.append(testName)
    }
    
}
    
let observer2 = TestObserver2()

class TMObserverTests: XCTestCase {
    
    override class func setUp() {
        super.setUp()
        XCTestObservationCenter.shared.addTestObserver(observer2)
    }
    
    override class func tearDown() {
        super.tearDown()
        XCTestObservationCenter.shared.removeTestObserver(observer2)
    }
    
    
    
    func test1() {
        XCTAssert(observer2.finishedTestCaseNames == [], "TestName is incorrect!")
    }
    
    
    func test2() {
        XCTAssert(observer2.finishedTestCaseNames == ["-[TMObserverTests test1]"], "TestName is incorrect!")
    }
    
    func test3() {
        XCTAssert(observer2.finishedTestCaseNames == ["-[TMObserverTests test1]", "-[TMObserverTests test2]"], "TestName is incorrect!")
    }

    
}
