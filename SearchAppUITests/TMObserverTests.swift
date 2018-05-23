//
//  TMObserverTestsMock.swift
//  UITMTests
//
//  Created by Lu Cui (LCL) on 2018-04-24.
//  Copyright © 2018 lcl. All rights reserved.
//

import XCTest

//Setting up mocking classes
class TestObserver: TMObserver {

//    public static var shared2 = TestObserver()
//
//    var testStatus :Bool?
//    var testName : String?
//    var testCaseKey : String?
//    var testComments : String?
//
//    // hoook for pre-test setup
//    func testBundleWillStart(_ testBundle: Bundle){
//
//    }
//
//    func testCaseDidFinish(_ testCase: XCTestCase) {
//        //        super.testCaseDidFinish(testCase)
//        testStatus = testCase.testRun?.hasSucceeded
//        testName = testCase.name
//        testCaseKey = testCase.metaData.testID
//        testComments = testCase.metaData.comments
//    }
//
//    func testCase(_ testCase: XCTestCase, didFailWithDescription description: String, inFile filePath: String?, atLine lineNumber: Int) {
//        print("test case failed")
//        testCase.metaData.comments = "<br>Test page is not loaded properly<br/><img src=\'https://s3.amazonaws.com/uitm2/2EF7357D-7E96-4E8A-A0A0-1526223AE572-71310-00018ADD0E893689.png\'>"
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

//
//class DummyTests: XCTestCaseMock {
//
//    override func setUp() {
//        super.setUp()
//        XCUIApplication().launch()
//    }
//
//
//    func test1()  {
//        self.metaData.comments = "This is a dummy test 1"
//        self.metaData.testID = "GOLM-T1"
//        (self.testRun as! XCTestCaseRunMock).hasSucceeded = true
//    }
//
//    func test2()  {
//        self.metaData.testID = "GOLM-T2"
//        (self.testRun as! XCTestCaseRunMock).hasSucceeded = false
//    }
//
//}

class ATMMock :ATMProtocol {
    var url :String?
    var entries : [String : Any]?
    var headers : [String : String]?
    
    
    
    func postTestResult(testRunKey: String, testCaseKey: String, testStatus: String, environment: String, comments:String, exedutionTime: Int) {
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
       
//        let testcase = DummyTests.init(selector:#selector(DummyTests.test1))
//        testcase.invokeTest()
        
        let testMock = XCTestCaseMock()
        testMock.metaData.comments = "test"
        testMock.metaData.testID = "T1"
        (testMock.testRun as! XCTestCaseRunMock).hasSucceeded = true
//        testMock.testRun?.testDuration = 1000
        
        
        let mockedATM = ATMMock()
        let observer = TMObserver(ATM:mockedATM)
        
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
        let testcase = DummyTests.init(selector:#selector(DummyTests.test2))
        let failMessage = "Test page is not loaded properly"
        testcase.invokeTest()
//        TestObserver.shared2.testCase(testcase, didFailWithDescription: failMessage,inFile: nil, atLine: 0)
//        TestObserver.shared2.testCaseDidFinish(testcase)
//        
//        XCTAssert(TestObserver.shared2.testName == "-[DummyTests test2]", "TestName is incorrect!")
//        XCTAssert(TestObserver.shared2.testCaseKey == "GOLM-T2", "Test Key is incorrect!")
//        XCTAssert(TestObserver.shared2.testStatus == false, "Test status is incorrect!")
//        XCTAssert(TestObserver.shared2.testComments!.starts(with: "<br>Test page is not loaded properly<br/>"), "Test comment is incorrect!")
    }

}
