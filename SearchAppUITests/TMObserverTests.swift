//
//  TMObserverTestsMock.swift
//  UITMTests
//
//  Created by Lu Cui (LCL) on 2018-04-24.
//  Copyright © 2018 lcl. All rights reserved.
//

import XCTest

public class XCTestCaseRunMock : XCTestCaseRun{
    var status :Bool = false
    var duration: TimeInterval = 0

    override open var hasSucceeded: Bool {
        get {
            return status
        }
        set {
            status = newValue
        }
    }
    
    override open var testDuration: TimeInterval {
        get {
            return testDuration
        }
        set {
            duration = newValue
        }
    }
}

public class XCTestCaseMock : XCTestCase{
    open override var testRunClass: AnyClass? {
        return XCTestCaseRunMock.self
    }
}

class ATMMock :ATMProtocol {
    static var url :String?
    static var entries : [String : Any]?
    static var headers : [String : String]?
    
    static func postTestResult(testRunKey: String, testCaseKey: String, testStatus: String, environment: String, comments:String, exedutionTime: Int) {
        url = "\(UITM.ATMBaseURL!)/testrun/\(testRunKey)/testcase/\(testCaseKey)/testresult"
        entries = [
            "status"        : testStatus,
            "environment"   : environment,
            "comment"       : comments,
            "executionTime": exedutionTime
            ] as [String : Any]
        headers = ["authorization": UITM.ATMCredential!]
    }
}


class TMObserverTests: XCTestCase {
    

    // Test Meta data of a succeeded test
    func testSuccessedTestCase() {
        
        let testMock = XCTestCaseMock()
        testMock.metaData.comments = "test"
        testMock.metaData.testID = "T1"
        (testMock.testRun as! XCTestCaseRunMock).hasSucceeded = true
        (testMock.testRun as! XCTestCaseRunMock).testDuration = 45.2
        
        let mockedATM = ATMMock()
        let observer = TMObserver(ATMType:ATMMock.self)
        
        observer.testCaseDidFinish(testMock)
        
//        XCTAssert(mockedATM.url == "-[DummyTests test1]", "TestName is incorrect!")
//        XCTAssert(mockedATM.entries)
//        XCTAssert(mockedATM.headers == ["":""])

//        XCTAssert(TMObserver.shared2.testName == "-[DummyTests test1]", "TestName is incorrect!")
//        XCTAssert(TMObserver.shared2.testCaseKey == "GOLM-T1", "Test Key is incorrect!")
//        XCTAssert(TestObserver.shared2.testStatus == true, "Test status is incorrect!")
//        XCTAssert(TestObserver.shared2.testComments!.starts(with: "This is a dummy test 1"), "Test comment is incorrect!")
    }

    // Test Meta data of a failed test
    func testFailedTestCase() {
//        let testcase = DummyTests.init(selector:#selector(DummyTests.test2))
//        let failMessage = "Test page is not loaded properly"
//        testcase.invokeTest()
//        TestObserver.shared2.testCase(testcase, didFailWithDescription: failMessage,inFile: nil, atLine: 0)
//        TestObserver.shared2.testCaseDidFinish(testcase)
//        
//        XCTAssert(TestObserver.shared2.testName == "-[DummyTests test2]", "TestName is incorrect!")
//        XCTAssert(TestObserver.shared2.testCaseKey == "GOLM-T2", "Test Key is incorrect!")
//        XCTAssert(TestObserver.shared2.testStatus == false, "Test status is incorrect!")
//        XCTAssert(TestObserver.shared2.testComments!.starts(with: "<br>Test page is not loaded properly<br/>"), "Test comment is incorrect!")
    }

}
