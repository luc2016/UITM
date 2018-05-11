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

class ATM {
    static let baseURL =  ProcessInfo.processInfo.environment["ATM_BASE_URL"] ?? "https://jira.lblw.ca/rest/atm/1.0"
    
    enum TestStatus : String {
        case pass = "Pass"
        case fail = "Fail"
        case inProgress = "In Progress"
        case blocked = "Blocked"
        case notExecuted = "Not Executed"
    }

    
    static func postTestResult(testRunKey: String, testCaseKey: String, testStatus: TestStatus, environment: String, comments:String, exedutionTime: Int) -> Bool{
        
        let headers = ["authorization": "Basic RmVycmlzOmZlcnJpcw=="]

        let entries = [
            "status"        : testStatus.rawValue,
            "environment"   : environment,
            "comment"       : comments,
            "executionTime": exedutionTime
            ] as [String : Any]
        
        let response = Alamofire.request("\(baseURL)/testrun/\(testRunKey)/testcase/\(testCaseKey)/testresult", method: .post, parameters: entries, encoding: JSONEncoding.default, headers:headers).validate().responseJSON()
        
        print(response)
        return response.result.isSuccess
    }
    
}
