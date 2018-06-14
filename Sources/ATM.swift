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

public protocol SessionManagerProtocol {
    func jsonResponse(_ url: URLConvertible, method: HTTPMethod, parameters: Parameters?, headers: HTTPHeaders?) -> DataResponse<Any>
}

extension Alamofire.SessionManager : SessionManagerProtocol {
    public func jsonResponse(_ url: URLConvertible, method: HTTPMethod, parameters: Parameters?, headers: HTTPHeaders?) -> DataResponse<Any> {
        return self.request(url, method: method, parameters: parameters, encoding: JSONEncoding.default, headers: headers).validate().responseJSON()
    }
}

class ATM {
    
    var sessionManager: SessionManagerProtocol

    init(sessionManager:SessionManagerProtocol = Alamofire.SessionManager.default) {
        self.sessionManager = sessionManager
    }
    
    func uploadTestResult(testId:String, testComments:String, testStatus:String, testDuration:Int, testRunKey:String = UITM.testRunKey!, ATMBaseURL:String = UITM.ATMBaseURL!, ATMCredential: String = UITM.ATMCredential!, ATMEnv:String = UITM.ATMENV!) ->  DataResponse<Any> {
        
        let url = "\(ATMBaseURL)/testrun/\(testRunKey)/testcase/\(testId)/testresult"
        let headers = ["authorization": "Basic " + ATMCredential]
        let entries = ["status": testStatus, "environment": ATMEnv, "comment": testComments, "executionTime": testDuration] as [String : Any]
        
        return sessionManager.jsonResponse(url, method: .post, parameters: entries, headers: headers)
    }
    
}
