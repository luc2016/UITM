//
//  ATMTests.swift
//  UnitTests
//
//  Created by Lu Cui (LCL) on 2018-06-17.
//  Copyright © 2018 lcl. All rights reserved.
//

import XCTest
import Alamofire
import Alamofire_Synchronous

enum NetworkError:Error{
    case uploadfailed
}

class SessionMockUploadSuccess : SessionManagerProtocol {
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

class SessionMockUploadFail : SessionManagerProtocol {
    var parameters : [String : Any]?
    var url: String?
    var response : DataResponse<Any>?
    
    func jsonResponse(_ url: URLConvertible, method: HTTPMethod, parameters: Parameters?, headers: HTTPHeaders?) -> DataResponse<Any> {
        self.parameters = parameters
        self.url = url as? String
        
        let httpResponse = HTTPURLResponse(url: try! url.asURL(), statusCode: 401, httpVersion: "HTTP/1.1", headerFields: nil)
        let result = Result<Any>.failure(NetworkError.uploadfailed)
        response = DataResponse(request: nil, response: httpResponse, data:nil, result: result)
        return response!
    }
}


class ATMTests: XCTestCase {
    
    let atmMockSuccess = ATM(
        sessionManager: SessionMockUploadSuccess(),
        baseURL:    "https://jira.lblw.ca/rest/atm/1.0",
        credentials:"ZmVycmlzOmZlcnJpcw==",
        env:        "Mobile iOS",
        testRunKey: "R13"
    )
    
    let atmMockFail = ATM(
        sessionManager: SessionMockUploadFail(),
        baseURL:    "https://jira.lblw.ca/rest/atm/1.0",
        credentials:"ZmVycmlzOmZlcnJpcw==",
        env:        "Mobile iOS",
        testRunKey: "R13"
    )
    
    func testuploadTestResultSuccess() {
        let response = atmMockSuccess.uploadTestResult(testId: "T1", testComments: "test", testStatus: true, testDuration: 12.5)
        
        let session = atmMockSuccess.sessionManager as! SessionMockUploadSuccess
        XCTAssert(session.url == "https://jira.lblw.ca/rest/atm/1.0/testrun/R13/testcase/T1/testresult")
        XCTAssert(session.parameters!["status"] as! String == "Pass")
        XCTAssert(session.parameters!["comment"] as! String == "test")
        XCTAssert(session.parameters!["executionTime"] as! Int == 12500)
        XCTAssert(response.error == nil)
    }
    
    func testuploadTestResultFail() {
        let response = atmMockFail.uploadTestResult(testId: "T1", testComments: "test", testStatus: true, testDuration: 12.5)
        
        let session = atmMockFail.sessionManager as! SessionMockUploadFail
        XCTAssert(session.url == "https://jira.lblw.ca/rest/atm/1.0/testrun/R13/testcase/T1/testresult")
        XCTAssert(session.parameters!["status"] as! String == "Pass")
        XCTAssert(session.parameters!["comment"] as! String == "test")
        XCTAssert(session.parameters!["executionTime"] as! Int == 12500)
        XCTAssert(response.error != nil)
    } 
    
    func testuploadTestResultInvalidTestID() {
        
    }
        
    func testTestCaseDidFinishWithInvalidTestRunKey() {
        
    }
    
    func testTestCaseDidFinishWithInvaliedTMCredentials() {
        
    }

}
