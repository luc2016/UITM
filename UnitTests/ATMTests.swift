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
    let sessionManager = SessionMockUploadSuccess()
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
