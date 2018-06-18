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

class S3MockUploadSuccess : CloudStorage {
    var authenticationCallCount = 0
    var uploadImageWasCallCount = 0
    
    func uploadImage(imageURL: URL) throws -> String {
        uploadImageWasCallCount += 1
        return "http:s3/uitm2/abcd.jpg"
    }
    
    func authenticate() {
        authenticationCallCount += 1
    }
}

class S3MockUploadFail : CloudStorage {
    var authenticationCallCount = 0
    var uploadImageWasCallCount = 0
    
    func uploadImage(imageURL: URL) throws -> String {
        uploadImageWasCallCount += 1
        throw NetworkError.uploadfailed
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

    var s3MockUploadSuccess: CloudStorage?
    var s3MockUploadFail: CloudStorage?
    var observer: TMObserver?
    
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        
        s3MockUploadSuccess = S3MockUploadSuccess()
        s3MockUploadFail = S3MockUploadFail()

        observer = try? TMObserver(TMService:atmMockSuccess, attachScreenShot:true,CSService:s3MockUploadSuccess)
        XCTAssertNotNil(observer, "Observer is not initialized properly.")
        
        (testCaseMock.testRun as! XCTestCaseRunMock).hasSucceeded = true
        (testCaseMock.testRun as! XCTestCaseRunMock).testDuration = 45.2
    }
    
    /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    func testTestSuiteWillStartAttachScreenShot() {
        observer!.testSuiteWillStart(XCTestSuite.default)
        XCTAssertEqual((observer!.CSService as! S3MockUploadSuccess).authenticationCallCount, 1)
    }

    func testTestSuiteWillStartNotAttachScreenShot() {
        observer = try? TMObserver(TMService:atmMockSuccess, attachScreenShot:false, CSService:s3MockUploadSuccess)
        XCTAssertNotNil(observer, "Observer is not initialized properly.")

        observer!.testSuiteWillStart(XCTestSuite.default)
        XCTAssertEqual((observer!.CSService as! S3MockUploadSuccess).authenticationCallCount, 0)
    }

    ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    func testTestCaseDidFinishATMUploadSuccess() {
        testCaseMock.metaData.testID = "T1"
        testCaseMock.metaData.comments = "test comment"
        
        observer!.testCaseDidFinish(testCaseMock)
        XCTAssert(testCaseMock.metaData.comments == "<br>test comment<br/>", "The test comment is incorrect")
        XCTAssertEqual(getLastLogMsg(path: observer!.logPath), "Upload result successed for test case: T1!", "Log message is incorrect")
    }
    
    func testTestCaseDidFinishATMUploadSuccessWithFailureMessage() {
        testCaseMock.metaData.testID = "T1"
        testCaseMock.metaData.comments = "test comment"
        testCaseMock.metaData.failureMessage = "<br>failed<br/>"
        
        observer!.testCaseDidFinish(testCaseMock)
        XCTAssert(testCaseMock.metaData.comments == "<br>test comment<br/><br>failed<br/>", "The test comment is incorrect")
        XCTAssertEqual(getLastLogMsg(path: observer!.logPath), "Upload result successed for test case: T1!", "Log message is incorrect")
    }
    
    func testTestCaseDidFinishATMUploadFail() {
        testCaseMock.metaData.testID = "T2"
        testCaseMock.metaData.comments = "test comment"
        
        observer = try? TMObserver(TMService:atmMockFail, attachScreenShot:true, CSService:s3MockUploadSuccess)
        XCTAssertNotNil(observer, "Observer is not initialized properly.")

        observer!.testCaseDidFinish(testCaseMock)
        XCTAssert(testCaseMock.metaData.comments == "<br>test comment<br/>", "The test comment is incorrect")
        XCTAssertEqual(getLastLogMsg(path: observer!.logPath), "Result for testcase T2 failed to upload!", "log message is incorrect")
    }
    
    func testuploadTestResultNoTestID() {
        testCaseMock.metaData.comments = "test comment"
        observer = try? TMObserver(TMService:atmMockFail, attachScreenShot:true, CSService:s3MockUploadFail)
        XCTAssertNotNil(observer, "Observer is not initialized properly.")
        
        observer!.testCaseDidFinish(testCaseMock)
        XCTAssert(testCaseMock.metaData.comments == "<br>test comment<br/>", "The test comment is incorrect")
        XCTAssertEqual(getLastLogMsg(path: observer!.logPath), "Result for testcase  failed to upload!", "log message is incorrect")
    }
    
    func testuploadTestResultNoTestComments() {
        testCaseMock.metaData.testID = "T3"
        XCTAssert(testCaseMock.metaData.comments == "", "The test comment is incorrect")
        XCTAssertEqual(getLastLogMsg(path: observer!.logPath), "Upload result successed for test case: T3!", "Log message is incorrect")
    }

    
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    func testTestCaseFailedAttachScreenShotS3UploadSuccess() {
        observer!.testCase(testCaseMock, didFailWithDescription: "test failed", inFile: nil, atLine: 0)
        
        XCTAssertEqual((observer!.CSService as! S3MockUploadSuccess).uploadImageWasCallCount, 1)
        XCTAssert(testCaseMock.metaData.failureMessage == "<br>test failed<br/><img src=\'http:s3/uitm2/abcd.jpg\'>", "The failure message is incorrect")
        //assert take screen shot is called
    }
    
    func testTestCaseFailedAttachScreenShotS3UploadFail() {
        observer = try? TMObserver(TMService:atmMockSuccess, attachScreenShot:true, CSService:s3MockUploadFail)
        XCTAssertNotNil(observer, "Observer is not initialized properly.")
        observer!.testCase(testCaseMock, didFailWithDescription: "test failed", inFile: nil, atLine: 0)
        
        XCTAssertEqual((observer!.CSService as! S3MockUploadFail).uploadImageWasCallCount, 1)
        XCTAssert(testCaseMock.metaData.failureMessage == "<br>test failed<br/>", "The failure message is incorrect")
        //assert take screen shot is called
    }
    
    func testTestCaseFailedNotAttachScreenShot() {
        
        observer = try? TMObserver(TMService:atmMockSuccess, attachScreenShot:false, CSService:s3MockUploadSuccess)
        XCTAssertNotNil(observer, "Observer is not initialized properly.")
        observer!.testCase(testCaseMock, didFailWithDescription: "test failed", inFile: nil, atLine: 0)
        
        XCTAssert(testCaseMock.metaData.failureMessage == "<br>test failed<br/>")
        XCTAssertEqual((observer!.CSService as! S3MockUploadSuccess).uploadImageWasCallCount, 0)
    }

    private func getLastLogMsg(path: String) -> String {
        return ""
    }
    
}
