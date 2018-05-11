//
//  TMObserverTestsMock.swift
//  UITMTests
//
//  Created by Lu Cui (LCL) on 2018-04-24.
//  Copyright © 2018 lcl. All rights reserved.
//

import XCTest

class TestObserver: TMObserver {

    var testStatus :Bool?
    var testName : String?
    var testCaseKey : String?
    var testComments : String?

    override func testCaseDidFinish(_ testCase: XCTestCase) {
        super.testCaseDidFinish(testCase)
        testStatus = testCase.testRun?.hasSucceeded
        testName = testCase.name
        testCaseKey = testCase.testID
        testComments = testCase.testComments
    }
    
    override func testCase(_ testCase: XCTestCase, didFailWithDescription description: String, inFile filePath: String?, atLine lineNumber: Int) {
        print("test case failed")
        testCase.testComments = "<br>Test page is not loaded properly<br/><img src=\'https://s3.amazonaws.com/uitm2/2EF7357D-7E96-4E8A-A0A0-1526223AE572-71310-00018ADD0E893689.png\'>"
    }

}

public class XCTestCaseRunMock : XCTestCaseRun{
    var status :Bool = false

    override open var hasSucceeded: Bool {
        get {
            return status
        }
        set {
            status = newValue
        }
    }
}

public class XCTestCaseMock : XCTestCase{
    open override var testRunClass: AnyClass? {
        return XCTestCaseRunMock.self
    }
}

let observer = TestObserver()

class DummyTests: XCTestCaseMock {
    
    override func setUp() {
        super.setUp()
        XCUIApplication().launch()
    }


    func test1()  {
        self.testID = "GOLM-T1"
        self.testComments = "This is a dummy test 1"
        (self.testRun as! XCTestCaseRunMock).hasSucceeded = true
    }

    func test2()  {
        self.testID = "GOLM-T2"
        (self.testRun as! XCTestCaseRunMock).hasSucceeded = false
    }

}

class TMObserverTests: XCTestCase {

    override func setUp() {
        super.setUp()
        XCTestObservationCenter.shared.addTestObserver(observer)
    }

    override func tearDown() {
        super.tearDown()
        XCTestObservationCenter.shared.removeTestObserver(observer)
    }


    // Test Meta data of a succeeded test
    func testSuccessedTestCase() {
        let testcase = DummyTests.init(selector:#selector(DummyTests.test1))
        testcase.invokeTest()
        observer.testCaseDidFinish(testcase)

        XCTAssert(observer.testName == "-[DummyTests test1]", "TestName is incorrect!")
        XCTAssert(observer.testCaseKey == "GOLM-T1", "Test Key is incorrect!")
        XCTAssert(observer.testStatus == true, "Test status is incorrect!")
        XCTAssert(observer.testComments!.starts(with: "This is a dummy test 1"), "Test comment is incorrect!")
    }

    // Test Meta data of a failed test
    func testFailedTestCase() {
        let testcase = DummyTests.init(selector:#selector(DummyTests.test2))
        let failMessage = "Test page is not loaded properly"
        testcase.invokeTest()
        observer.testCase(testcase, didFailWithDescription: failMessage,inFile: nil, atLine: 0)
        observer.testCaseDidFinish(testcase)
        
        XCTAssert(observer.testName == "-[DummyTests test2]", "TestName is incorrect!")
        XCTAssert(observer.testCaseKey == "GOLM-T2", "Test Key is incorrect!")
        XCTAssert(observer.testStatus == false, "Test status is incorrect!")
        XCTAssert(observer.testComments!.starts(with: "<br>Test page is not loaded properly<br/>"), "Test comment is incorrect!")
    }

}
