//
//  ATM.swift
//  UITMTests
//
//  Created by Lu Cui (LCL) on 2018-04-25.
//  Copyright © 2018 lcl. All rights reserved.
//

import Foundation
import Alamofire
import Alamofire_Synchronous
import AWSS3

protocol SessionManagerProtocol {
    func jsonResponse(_ url: URLConvertible, method: HTTPMethod, parameters: Parameters?, headers: HTTPHeaders?) -> DataResponse<Any>
}

extension Alamofire.SessionManager : SessionManagerProtocol {
    func jsonResponse(_ url: URLConvertible, method: HTTPMethod, parameters: Parameters?, headers: HTTPHeaders?) -> DataResponse<Any> {
        return self.request(url, method: method, parameters: parameters, encoding: JSONEncoding.default, headers: headers).validate().responseJSON()
    }
}

class ATM {
    var sessionManager : SessionManagerProtocol
    
    init(_ sessionManager: SessionManagerProtocol = Alamofire.SessionManager.default){
        self.sessionManager = sessionManager
    }

    public func postTestResult(testRunKey: String, testCaseKey: String, testStatus: String, environment: String, comments:String, exedutionTime: Int) -> Result<Any> {
        
        
        let url = "\(UITM.ATMBaseURL!)/testrun/\(testRunKey)/testcase/\(testCaseKey)/testresult"
        let headers = ["authorization": UITM.ATMCredential!]

        let entries = [
            "status"        : testStatus,
            "environment"   : environment,
            "comment"       : comments,
            "executionTime": exedutionTime
            ] as [String : Any]
        
//        let response = networkManager.request(url, method: .post, parameters: entries, encoding: JSONEncoding.default, headers: headers).validate().responseJSON()
        let response = sessionManager.jsonResponse(url, method: .post, parameters: entries, headers: headers)

        if let error = response.error{
            print("Failed with error: \(error)")
            logFailedResults()
        }else{
            print("Uploaded test result successfully")
        }
        return response.result
        
    }

    private func logFailedResults() {
        
    }
    
}
