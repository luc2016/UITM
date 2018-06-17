//
//  ATM.swift
//  UITM
//
//  Created by Lu Cui (LCL) on 2018-06-14.
//  Copyright © 2018 lcl. All rights reserved.
//

import Foundation
import Alamofire
import Alamofire_Synchronous

//public protocol TMConfig {}
//
//public struct ATMConfig: TMConfig{
//    var baseURL:    String
//    var credentials:String
//    var statuses:   (pass:String, fail:String)
//    var env:        String
//    var testRunKey: String
//}

protocol TestManagement {
    func uploadTestResult(testId:String, testComments:String, testStatus:Bool, testDuration:TimeInterval) ->  DataResponse<Any>
}

public protocol SessionManagerProtocol {
    func jsonResponse(_ url: URLConvertible, method: HTTPMethod, parameters: Parameters?, headers: HTTPHeaders?) -> DataResponse<Any>
}

extension Alamofire.SessionManager : SessionManagerProtocol {
    public func jsonResponse(_ url: URLConvertible, method: HTTPMethod, parameters: Parameters?, headers: HTTPHeaders?) -> DataResponse<Any> {
        return self.request(url, method: method, parameters: parameters, encoding: JSONEncoding.default, headers: headers).validate().responseJSON()
    }
}

class ATM: TestManagement {
    
    var sessionManager: SessionManagerProtocol
//    var config: ATMConfig = UITM.TMConfig as! ATMConfig
    var baseURL:    String
    var credentials:String
    var statuses:   (pass:String, fail:String)
    var env:        String
    var testRunKey: String

    init(sessionManager:SessionManagerProtocol = Alamofire.SessionManager.default, baseURL:String, credentials:String,env:String,testRunKey:String,statuses:(pass:String, fail:String)) {
        self.sessionManager = sessionManager
//        self.config = config as! ATMConfig
        self.baseURL = baseURL
        self.credentials = credentials
        self.statuses = statuses
        self.env = env
        self.testRunKey = testRunKey
    }
    
    func uploadTestResult(testId:String, testComments:String, testStatus:Bool, testDuration:TimeInterval) ->  DataResponse<Any> {
        
        let url = "\(config.baseURL)/testrun/\(config.testRunKey)/testcase/\(testId)/testresult"
        let headers = ["authorization": "Basic " + config.credentials]
        let entries = ["status": testStatus ? config.statuses.pass : config.statuses.fail, "environment": config.env, "comment": testComments, "executionTime": Int(testDuration as! Double * 1000)] as [String : Any]
        
        return sessionManager.jsonResponse(url, method: .post, parameters: entries, headers: headers)
    }
    
}
