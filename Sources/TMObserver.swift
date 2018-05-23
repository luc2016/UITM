//
//  TMObserver.swift
//  XCUI_UITM
//
//  Created by Lu Cui (LCL) on 2018-04-17.
//  Copyright © 2018 lcl. All rights reserved.
//

import Foundation
import XCTest


class TMObserver : NSObject, XCTestObservation  {
    
    var ATMServer :ATMProtocol.Type
    
    init(ATMType:ATMProtocol.Type = ATM.self){
        ATMServer = ATMType
    }
    
    // hoook for pre-test setup
    public func testBundleWillStart(_ testBundle: Bundle){
        //authtnticate using aws cognito
        if(UITM.attachScreenShot!) {
            S3.authenticate(identityPoolId: UITM.S3CognitoKey!, regionType: UITM.S3RegionType!)
        }
    }

    //hook for test finished
    public func testCaseDidFinish(_ testCase: XCTestCase) {
        print("test case Finished")
        let testStatus =  (testCase.testRun?.hasSucceeded)! ? UITM.ATMStatuses!.pass : UITM.ATMStatuses!.fail
        let testDuration = Int(testCase.testRun?.testDuration as! Double * 10000)
        let comments = "<br>\(testCase.metaData.comments)<br/>" + testCase.metaData.failureMessage
        
        //post test results to ATM
        ATMServer.postTestResult(testRunKey: UITM.testRunKey!, testCaseKey: testCase.metaData.testID!, testStatus: testStatus, environment: UITM.ATMENV!, comments: comments, exedutionTime: testDuration)
    }
    
    //hook for failed test case
    public func testCase(_ testCase: XCTestCase, didFailWithDescription description: String, inFile filePath: String?, atLine lineNumber: Int) {
        print("test case failed")
        if(UITM.attachScreenShot!) {
            let imageURL = takeScreenShot()
            let s3address = S3.uploadImage(bucketName: UITM.S3BuecktName!, imageURL: imageURL)
            testCase.metaData.failureMessage = "<br>\(description)<br/><img src='\(s3address)'>"
        }
    }
    
}
