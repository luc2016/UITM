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
    let baseURL = "https://jira.lblw.ca/rest/atm/1.0"
    
    static func postTestResult(testRunKey: String, testCaseKey: String, testStatus: Bool, attachment:Data?){
        
        let headers = ["authorization": "Basic RmVycmlzOmZlcnJpcw=="]
        let status = testStatus ? "Pass" : "Fail"

        let entries = [
            "status"        : status,
            "environment"   : "Mobile iOS",
            "comment"       : "The test has failed",
            "scriptResults" : [
                [
                    "index": 0,
                    "status": status
                ]
            ]
            ] as [String : Any]
        
        
//        let response = Alamofire.request("https://jira.lblw.ca/rest/atm/1.0/testrun/\(testRunKey)/testcase/\(testCaseKey)/testresult", method: .post, parameters: entries, encoding: JSONEncoding.default, headers:headers).validate().responseJSON()

    
    }
    
    static func postAttachment(testCaseKey: String, image: String){
        
        
    }


}
