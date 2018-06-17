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

class SessionManagerMock : SessionManagerProtocol {
    var parameters : [String : Any]?
    var url: String?
    var response : DataResponse<Any>?
    
    func jsonResponse(_ url: URLConvertible, method: HTTPMethod, parameters: Parameters?, headers: HTTPHeaders?) -> DataResponse<Any> {
        self.parameters = parameters
        self.url = url as? String
        
        let httpResponse = HTTPURLResponse(url: try! url.asURL(), statusCode: 201, httpVersion: "HTTP/1.1", headerFields: nil)
        let result = Result.success(["id":"493067"] as Any)
        response = DataResponse(request: nil, response: httpResponse, data:nil, result: result)
        return response!
    }
}


class TMObserverTests: XCTestCase {
    let testCaseMock = XCTestCaseMock()
    let sessionManager = SessionManagerMock()
    var observer : TMObserver?
    
    override func setUp() {
        observer = TMObserver(CS: S3Mock())
    }
    
    /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    // Test Meta data of a failed test
//    func testTestSuiteWillStartAttachScreenShot() {
//        observer!.testSuiteWillStart(XCTestSuite.default)
//        XCTAssertEqual(observer?.CSService.authenticationCallCount, 1)
//    }
//
//    func testTestSuiteWillStartNotAttachScreenShot() {
//        UITM.attachScreenShot = false
//        observer!.testSuiteWillStart(XCTestSuite.default)
//        XCTAssertEqual(observer?.CSService.authenticationCallCount, 0)
//    }

    ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    // Test Meta data of a succeeded test
    func testTestCaseDidFinishAWSNetworkSuccess() {
        
//        observer = TMObserver(sessionManager: sessionManager, storageType: S3Mock.self)
        
        testCaseMock.metaData.comments = "test comment"
        testCaseMock.metaData.testID = "T1"
        (testCaseMock.testRun as! XCTestCaseRunMock).hasSucceeded = true
        (testCaseMock.testRun as! XCTestCaseRunMock).testDuration = 45.2
        
        observer!.testCaseDidFinish(testCaseMock)
        
        XCTAssert(sessionManager.url == "https://jira.lblw.ca/rest/atm/1.0/testrun/R13/testcase/T1/testresult")
        XCTAssert(sessionManager.parameters!["status"] as! String == "Pass")
        XCTAssert(sessionManager.parameters!["comment"] as! String == "<br>test comment<br/>")
        XCTAssert(sessionManager.parameters!["executionTime"] as! Int == 45200)
        //find better way to determin network call passed
        //Assert that nothing is output to log
        
    }
    
    func testTestCaseDidFinishAWSNetworkFail() {
//        observer = TMObserver(sessionManager: sessionManager, storageType: S3Mock.self)
        
        testCaseMock.metaData.comments = "test comment"
        testCaseMock.metaData.testID = "T1"
        (testCaseMock.testRun as! XCTestCaseRunMock).hasSucceeded = true
        (testCaseMock.testRun as! XCTestCaseRunMock).testDuration = 45.2
        
        observer!.testCaseDidFinish(testCaseMock)
        
        XCTAssert(sessionManager.url == "https://jira.lblw.ca/rest/atm/1.0/testrun/R13/testcase/T1/testresult")
        XCTAssert(sessionManager.parameters!["status"] as! String == "Pass")
        XCTAssert(sessionManager.parameters!["comment"] as! String == "<br>test comment<br/>")
        XCTAssert(sessionManager.parameters!["executionTime"] as! Int == 45200)
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

//    func testTestCaseFailedNoScreenShot() {
//        UITM.attachScreenShot = false
//        observer!.testCase(testCaseMock, didFailWithDescription: "test failed", inFile: nil, atLine: 0)
//        XCTAssertEqual(S3Mock.uploadImageWasCallCount, 0)
//    }
//
//    func testTestCaseFailedWithScreenShot() {
//        observer!.testCase(testCaseMock, didFailWithDescription: "test failed", inFile: nil, atLine: 0)
//        XCTAssertEqual(S3Mock.uploadImageWasCallCount, 1)
//        XCTAssert(testCaseMock.metaData.failureMessage == "<br>test failed<br/><img src=\'http:s3/uitm2/abcd.jpg\'>")
//    }
//
//    func  testTestCaseFailedWithScreenShotappendToLog(){
//        self.metaData.testID = "GOLM-T1"
//        self.metaData.comments = "test me no app target"
////        XCTFail("dd")
//    }
    
}
