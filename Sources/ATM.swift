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

protocol ATMProtocol {
     static func postTestResult(testRunKey: String, testCaseKey: String, testStatus: String, environment: String, comments:String, exedutionTime: Int)
}

class ATM :ATMProtocol{

     static func postTestResult(testRunKey: String, testCaseKey: String, testStatus: String, environment: String, comments:String, exedutionTime: Int) {
        
        let headers = ["authorization": UITM.ATMCredential!]

        let entries = [
            "status"        : testStatus,
            "environment"   : environment,
            "comment"       : comments,
            "executionTime": exedutionTime
            ] as [String : Any]
        
        let response = Alamofire.request("\(UITM.ATMBaseURL!)/testrun/\(testRunKey)/testcase/\(testCaseKey)/testresult", method: .post, parameters: entries, encoding: JSONEncoding.default, headers: headers).validate().responseJSON()

        if let error = response.error {
            print("Failed with error: \(error)")
            fatalError("ATM uploading failed with error: \(error)")
        }else{
            print("Uploaded test result successfully")
        }
    }
    
}
