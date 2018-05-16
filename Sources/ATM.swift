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

<<<<<<< HEAD
    static func postTestResult(testRunKey: String, testCaseKey: String, testStatus: String, environment: String, comments:String, exedutionTime: Int) {
        
        let headers = ["authorization": UITM.ATMCredential!]

        let entries = [
            "status"        : testStatus,
=======
    enum TestStatus : String {
        case pass = "Pass"
        case fail = "Fail"
        case inProgress = "In Progress"
        case blocked = "Blocked"
        case notExecuted = "Not Executed"
    }

    
    static func postTestResult(testRunKey: String, testCaseKey: String, testStatus: TestStatus, environment: String, comments:String, exedutionTime: Int) {
        
        let headers = ["authorization": UITM.ATMCredentials]

        let entries = [
            "status"        : testStatus.rawValue,
>>>>>>> 261e9ab6d25ed3c180c0fac297ce298102a218bb
            "environment"   : environment,
            "comment"       : comments,
            "executionTime": exedutionTime
            ] as [String : Any]
        
<<<<<<< HEAD
        let response = Alamofire.request("\(UITM.ATMBaseURL!)/testrun/\(testRunKey)/testcase/\(testCaseKey)/testresult", method: .post, parameters: entries, encoding: JSONEncoding.default, headers: headers).validate().responseJSON()

        if let error = response.error {
            print("Failed with error: \(error)")
            fatalError("ATM uploading failed with error: \(error)")
        }else{
            print("Uploaded test result successfully")
        }
=======
        let response = Alamofire.request("\(UITM.ATMBaseURL)/testrun/\(testRunKey)/testcase/\(testCaseKey)/testresult", method: .post, parameters: entries, encoding: JSONEncoding.default, headers:headers).validate().responseJSON()
        
>>>>>>> 261e9ab6d25ed3c180c0fac297ce298102a218bb
    }
    
}
