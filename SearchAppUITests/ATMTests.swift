//
//  ATMTests.swift
//  SearchAppUITests
//
//  Created by Lu Cui (LCL) on 2018-05-27.
//  Copyright © 2018 lcl. All rights reserved.
//

import XCTest
import Alamofire

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

class ATMTests: XCTestCase {
    
    func testPostTestResult() {
        let sessionManager = SessionManagerMock()
        let result = ATM(sessionManager).postTestResult(testRunKey: "R13", testCaseKey: "T1", testStatus: "Pass", environment: "Mobile iOS", comments: "test", exedutionTime: 100)
        XCTAssert(sessionManager.url == "https://jira.lblw.ca/rest/atm/1.0/testrun/R13/testcase/T1/testresult")
        XCTAssert(sessionManager.parameters!["status"] as! String == "Pass")
        XCTAssert(sessionManager.parameters!["comment"] as! String == "test")
        XCTAssert(sessionManager.parameters!["executionTime"] as! Int == 100)
        XCTAssert(result.isSuccess == true)
    }
    
}
