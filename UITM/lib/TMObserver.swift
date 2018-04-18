//
//  TMObserver.swift
//  XCUI_UITM
//
//  Created by Lu Cui (LCL) on 2018-04-17.
//  Copyright © 2018 lcl. All rights reserved.
//

import Foundation

import XCTest
import Alamofire
//import Alamofire_Synchronous

public class TMObserver: NSObject, XCTestObservation {
    
    public static var shared = TMObserver()

    public func testCaseWillStart(_ testCase: XCTestCase) {
        print("test case Started")
    }

    public func testCaseDidFinish(_ testCase: XCTestCase) {
        print("test case Finished")
        let status = testCase.testRun?.hasSucceeded
        let duration = testCase.testRun?.testDuration
        let testName = testCase.name
        let description = testCase.testRun?.description

        let headers = ["authorization": "Basic RmVycmlzOmZlcnJpcw=="]
        let responseFromOauth = Alamofire.request("https://jira.lblw.ca/rest/atm/1.0/testrun/GOLM-R14", method: .get, headers:headers).validate().responseJSON()

    }

    public func testCase(_ testCase: XCTestCase,
                         didFailWithDescription description: String,
                         inFile filePath: String?,
                         atLine lineNumber: Int) {
        print("test case failed")
    }

}

//public class TMObserver {
//     public static let shared = TMObserver()
//
//     public func foo() {
//        print("test case Started")
//    }
//
//}

