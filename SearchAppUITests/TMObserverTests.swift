//
//  TMObserverTestsMock.swift
//  UITMTests
//
//  Created by Lu Cui (LCL) on 2018-04-24.
//  Copyright © 2018 lcl. All rights reserved.
//

import XCTest
import AWSCognito

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

class S3Mock : S3Protocol {
    static var authenticationCallCount = 0
    static var uploadImageWasCallCount = 0
    
    static func uploadImage(bucketName:String, imageURL: URL) -> String {
        uploadImageWasCallCount += 1
        return "http:s3/uitm2/abcd.jpg"
    }
    
    static func authenticate(identityPoolId: String, regionType:AWSRegionType) {
        authenticationCallCount += 1
    }
}


class TMObserverTests: XCTestCase {
    let testCaseMock = XCTestCaseMock()
    let sessionManager = SessionManagerMock()
    var observer : TMObserver?
    
    override func setUp() {
        observer = TMObserver(sessionManager: sessionManager, S3Type: S3Mock.self)
    }
    
    // Test Meta data of a succeeded test
    func testTestCaseDidFinishSuccess() {
        
        testCaseMock.metaData.comments = "test comment"
        testCaseMock.metaData.testID = "T1"
        (testCaseMock.testRun as! XCTestCaseRunMock).hasSucceeded = true
        (testCaseMock.testRun as! XCTestCaseRunMock).testDuration = 45.2
        
        observer!.testCaseDidFinish(testCaseMock)
        
        XCTAssert(sessionManager.url == "https://jira.lblw.ca/rest/atm/1.0/testrun/R13/testcase/T1/testresult")
        XCTAssert(sessionManager.parameters!["status"] as! String == "Pass")
        XCTAssert(sessionManager.parameters!["comment"] as! String == "<br>test comment<br/>")
        XCTAssert(sessionManager.parameters!["executionTime"] as! Int == 452000)
        
    }
    
//    func testTestCaseDidFinishFail() {
//        
//        testCaseMock.metaData.comments = "test comment"
//        testCaseMock.metaData.testID = "T1"
//        (testCaseMock.testRun as! XCTestCaseRunMock).hasSucceeded = false
//        (testCaseMock.testRun as! XCTestCaseRunMock).testDuration = 45.2
//        
//        
//        observer!.testCaseDidFinish(testCaseMock)
//        
////        XCTAssert(ATMMock.url == "https://jira.lblw.ca/rest/atm/1.0/testrun/R13/testcase/T1/testresult")
////        XCTAssert(ATMMock.entries!["status"] as! String == "Pass")
////        XCTAssert(ATMMock.entries!["comment"] as! String == "<br>test comment<br/>")
////        XCTAssert(ATMMock.entries!["executionTime"] as! Int == 452000)
//        
//    }

    // Test Meta data of a failed test
    func testTestSuiteWillStartWithScreenShot() {
        observer!.testSuiteWillStart(XCTestSuite.default)
        XCTAssertEqual(S3Mock.authenticationCallCount, 1)
    }


    func testTestBundleWillStartNoScreenShot() {
        UITM.attachScreenShot = false
        observer!.testSuiteWillStart(XCTestSuite.default)
        XCTAssertEqual(S3Mock.authenticationCallCount, 0)
    }

    func testTestCaseFailedNoScreenShot() {
        UITM.attachScreenShot = false
        observer!.testCase(testCaseMock, didFailWithDescription: "test failed", inFile: nil, atLine: 0)
        XCTAssertEqual(S3Mock.uploadImageWasCallCount, 0)
    }
    
    func testTestCaseFailedWithScreenShot() {
        observer!.testCase(testCaseMock, didFailWithDescription: "test failed", inFile: nil, atLine: 0)
        XCTAssertEqual(S3Mock.uploadImageWasCallCount, 1)
        XCTAssert(testCaseMock.metaData.failureMessage == "<br>test failed<br/><img src=\'http:s3/uitm2/abcd.jpg\'>")
    }

}
