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

    override func testCaseDidFinish(_ testCase: XCTestCase) {
        super.testCaseDidFinish(testCase)
        testStatus = testCase.testRun?.hasSucceeded
        testName = testCase.name
        testCaseKey = testCase.testID
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
let testRunKey = "GOLM-R13"

class DummyTests: XCTestCaseMock {

    func test1()  {
        self.testID = "GOLM-T1"
        (self.testRun as! XCTestCaseRunMock).hasSucceeded = true
    }

    func test2()  {
        self.testID = "GOLM-T2"
        (self.testRun as! XCTestCaseRunMock).hasSucceeded = false
//        XCTFail()
    }

}

class TMObserverTestsMock: XCTestCase {

    override func setUp() {
        super.setUp()
        XCTestObservationCenter.shared.addTestObserver(observer)
    }

    override func tearDown() {
        super.tearDown()
        XCTestObservationCenter.shared.removeTestObserver(observer)
    }


    // Test Meta data of a succeeded test
    func test1SuccessedTestCase() {
        let testcase = DummyTests.init(selector:#selector(DummyTests.test1))
        testcase.invokeTest()
        observer.testCaseDidFinish(testcase)
        
        XCTAssert(observer.testName == "-[DummyTests test1]", "TestName is incorrect!")
        XCTAssert(observer.testCaseKey == "GOLM-T1", "Test Key is incorrect!")
        XCTAssert(observer.testStatus == true, "Test status is incorrect!")
    }

//    // Test Meta data of a succeeded test
    func test2FailedTestCase() {

        let testcase = DummyTests.init(selector:#selector(DummyTests.test2))
        testcase.invokeTest()
        observer.testCaseDidFinish(testcase)
        
        XCTAssert(observer.testName == "-[DummyTests test2]", "TestName is incorrect!")
        XCTAssert(observer.testCaseKey == "T2", "Test Key is incorrect!")
        XCTAssert(observer.testStatus == false, "Test status is incorrect!")
    }

}
