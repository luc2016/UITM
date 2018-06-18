//
//  TMObserverTestsMock.swift
//  UITMTests
//
//  Created by Lu Cui (LCL) on 2018-04-24.
//  Copyright © 2018 lcl. All rights reserved.
//

import XCTest
import AWSCognito
import Alamofire
import Alamofire_Synchronous

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
            return duration
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

class S3Mock : CloudStorage {
    var authenticationCallCount = 0
    var uploadImageWasCallCount = 0
    
    func uploadImage(imageURL: URL) -> String {
        uploadImageWasCallCount += 1
        return "http:s3/uitm2/abcd.jpg"
    }
    
    func authenticate() {
        authenticationCallCount += 1
    }
}

class TMObserverTests: XCTestCase {
    let testCaseMock = XCTestCaseMock()
    let atmMockSuccess = ATM(
        sessionManager: SessionMockUploadSuccess(),
        baseURL:    "https://jira.lblw.ca/rest/atm/1.0",
        credentials:"ZmVycmlzOmZlcnJpcw==",
        env:        "Mobile iOS",
        testRunKey: "GOLM-R13"
    )
    
    let atmMockFail = ATM(
        sessionManager: SessionMockUploadFail(),
        baseURL:    "https://jira.lblw.ca/rest/atm/1.0",
        credentials:"ZmVycmlzOmZlcnJpcw==",
        env:        "Mobile iOS",
        testRunKey: "GOLM-R13"
    )

    let s3Mock = S3Mock()
    var observer: TMObserver?
    
    override func setUp() {
        observer = try? TMObserver(TMService:atmMockSuccess, attachScreenShot:true,CSService:s3Mock)
        XCTAssertNotNil(observer, "Observer is not initialized properly.")
        
        testCaseMock.metaData.comments = "test comment"
        testCaseMock.metaData.testID = "T1"
        (testCaseMock.testRun as! XCTestCaseRunMock).hasSucceeded = true
        (testCaseMock.testRun as! XCTestCaseRunMock).testDuration = 45.2
    }
    
    /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    func testTestSuiteWillStartAttachScreenShot() {
        observer!.testSuiteWillStart(XCTestSuite.default)
        XCTAssertEqual((observer!.CSService as! S3Mock).authenticationCallCount, 1)
    }

    func testTestSuiteWillStartNotAttachScreenShot() {
        observer = try? TMObserver(TMService:atmMockSuccess, attachScreenShot:false, CSService:s3Mock)
        XCTAssertNotNil(observer, "Observer is not initialized properly.")

        observer!.testSuiteWillStart(XCTestSuite.default)
        XCTAssertEqual((observer!.CSService as! S3Mock).authenticationCallCount, 0)
    }

    ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    // Test Meta data of a succeeded test
    func testTestCaseDidFinishATMUploadSuccess() {
        
        observer!.testCaseDidFinish(testCaseMock)
        XCTAssertEqual( getLastLogMsg(path: observer!.logPath), "Upload result successed for test case: T1!", "String")
        
//        XCTAssert(sessionManager.url == "https://jira.lblw.ca/rest/atm/1.0/testrun/R13/testcase/T1/testresult")
//        XCTAssert(sessionManager.parameters!["status"] as! String == "Pass")
//        XCTAssert(sessionManager.parameters!["comment"] as! String == "<br>test comment<br/>")
//        XCTAssert(sessionManager.parameters!["executionTime"] as! Int == 45200)
        //find better way to determin network call passed
        //Assert that nothing is output to log
        
    }
    
    func testTestCaseDidFinishATMUploadFail() {
        
        observer = try? TMObserver(TMService:atmMockFail, attachScreenShot:true, CSService:s3Mock)
        XCTAssertNotNil(observer, "Observer is not initialized properly.")

        
        observer!.testCaseDidFinish(testCaseMock)
        XCTAssertEqual(getLastLogMsg(path: observer!.logPath), "Upload result successed for test case: T1!", "String")

//        XCTAssert(sessionManager.url == "https://jira.lblw.ca/rest/atm/1.0/testrun/R13/testcase/T1/testresult")
//        XCTAssert(sessionManager.parameters!["status"] as! String == "Pass")
//        XCTAssert(sessionManager.parameters!["comment"] as! String == "<br>test comment<br/>")
//        XCTAssert(sessionManager.parameters!["executionTime"] as! Int == 45200)
        //assert that failed test case information is logged
        
    }
    
    func testTestCaseDidFinishWithNoTestID() {
        
    }
    
    func testTestCaseDidFinishWithNoTestComments() {
        
    }
    
    func testTestCaseDidFinishWithFailedTestStatus() {
        
    }
    
    func testTestCaseDidFinishWithInvalidTestRunKey() {
        
    }
    
    func testTestCaseDidFinishWithInvalidTestID() {
        
    }
    
    func testTestCaseDidFinishWithInvaliedTMCredentials() {
        
    }
    
    
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    func testTestCaseFailedAttachScreenShot() {
        observer!.testCase(testCaseMock, didFailWithDescription: "test failed", inFile: nil, atLine: 0)
        
        XCTAssertEqual((observer!.CSService as! S3Mock).uploadImageWasCallCount, 1)
        XCTAssert(testCaseMock.metaData.failureMessage == "<br>test failed<br/><br>test failed<br/><img src=\'http:s3/uitm2/abcd.jpg\'>")
    }
    
    func testTestCaseFailedNotAttachScreenShot() {
        
        observer = try? TMObserver(TMService:atmMockSuccess, attachScreenShot:false, CSService:s3Mock)
        XCTAssertNotNil(observer, "Observer is not initialized properly.")
        observer!.testCase(testCaseMock, didFailWithDescription: "test failed", inFile: nil, atLine: 0)
        
        XCTAssert(testCaseMock.metaData.failureMessage == "<br>test failed<br/>")
        XCTAssertEqual((observer!.CSService as! S3Mock).uploadImageWasCallCount, 0)
    }

    
    private func getLastLogMsg(path: String) -> String {
        return ""
    }
    
}
