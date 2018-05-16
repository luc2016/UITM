//
//  TMObserverTestsMock.swift
//  UITMTests
//
//  Created by Lu Cui (LCL) on 2018-04-24.
//  Copyright © 2018 lcl. All rights reserved.
//

import XCTest

class TestObserver: TMObserver {
    
    public static var shared = TestObserver()

    var testStatus :Bool?
    var testName : String?
    var testCaseKey : String?
    var testComments : String?

    override func testCaseDidFinish(_ testCase: XCTestCase) {
//        super.testCaseDidFinish(testCase)
        testStatus = testCase.testRun?.hasSucceeded
        testName = testCase.name
        testCaseKey = testCase.metaData.testID
        testComments = testCase.metaData.testComments
    }
    
//    override func testCase(_ testCase: XCTestCase, didFailWithDescription description: String, inFile filePath: String?, atLine lineNumber: Int) {
//        print("test case failed")
//        testCase.testComments = "<br>Test page is not loaded properly<br/><img src=\'https://s3.amazonaws.com/uitm2/2EF7357D-7E96-4E8A-A0A0-1526223AE572-71310-00018ADD0E893689.png\'>"
//    }

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


class DummyTests: XCTestCaseMock {
    
    override func setUp() {
        super.setUp()
        XCUIApplication().launch()
    }


    func test1()  {
        self.metaData.testComments = "This is a dummy test 1"
        self.metaData.testID = "GOLM-T1"
        (self.testRun as! XCTestCaseRunMock).hasSucceeded = true
    }

    func test2()  {
        self.metaData.testID = "GOLM-T2"
        (self.testRun as! XCTestCaseRunMock).hasSucceeded = false
    }

}


class TMObserverTests: XCTestCase {

    // Test Meta data of a succeeded test
    func testSuccessedTestCase() {
        let testcase = DummyTests.init(selector:#selector(DummyTests.test1))
        testcase.invokeTest()
        TestObserver.shared.testCaseDidFinish(testcase)

        XCTAssert(TestObserver.shared.testName == "-[DummyTests test1]", "TestName is incorrect!")
        XCTAssert(TestObserver.shared.testCaseKey == "GOLM-T1", "Test Key is incorrect!")
        XCTAssert(TestObserver.shared.testStatus == true, "Test status is incorrect!")
        XCTAssert(TestObserver.shared.testComments!.starts(with: "This is a dummy test 1"), "Test comment is incorrect!")
    }

    // Test Meta data of a failed test
    func testFailedTestCase() {
        let testcase = DummyTests.init(selector:#selector(DummyTests.test2))
        let failMessage = "Test page is not loaded properly"
        testcase.invokeTest()
        TestObserver.shared.testCase(testcase, didFailWithDescription: failMessage,inFile: nil, atLine: 0)
        TestObserver.shared.testCaseDidFinish(testcase)
        
        XCTAssert(TestObserver.shared.testName == "-[DummyTests test2]", "TestName is incorrect!")
        XCTAssert(TestObserver.shared.testCaseKey == "GOLM-T2", "Test Key is incorrect!")
        XCTAssert(TestObserver.shared.testStatus == false, "Test status is incorrect!")
        XCTAssert(TestObserver.shared.testComments!.starts(with: "<br>Test page is not loaded properly<br/>"), "Test comment is incorrect!")
    }

}
