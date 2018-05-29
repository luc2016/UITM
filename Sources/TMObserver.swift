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
    
    var sessionManager: SessionManagerProtocol
    var S3Service: S3Protocol.Type
    
    public init(sessionManager: SessionManagerProtocol, S3Type:S3Protocol.Type = S3.self){
        self.sessionManager = sessionManager
        S3Service = S3Type
    }
    
    public func testSuiteWillStart(_ testSuite: XCTestSuite) {
        print("test suite \(testSuite.name) will start.")
        
        //authtnticate using aws cognito
        if(UITM.attachScreenShot!) {
            S3Service.authenticate(identityPoolId: UITM.S3CognitoKey!, regionType: UITM.S3RegionType!)
        }
    }


    //hook for test finished
    public func testCaseDidFinish(_ testCase: XCTestCase) {
        print("test case \(testCase.name) Finished")
        let testStatus =  (testCase.testRun?.hasSucceeded)! ? UITM.ATMStatuses!.pass : UITM.ATMStatuses!.fail
        let testDuration = Int(testCase.testRun?.testDuration as! Double * 10000)
        let comments = "<br>\(testCase.metaData.comments)<br/>" + testCase.metaData.failureMessage
        
        //post test results to ATM
        ATM(sessionManager).postTestResult(testRunKey: UITM.testRunKey!, testCaseKey: testCase.metaData.testID!, testStatus: testStatus, environment: UITM.ATMENV!, comments: comments, exedutionTime: testDuration)
        
    }
    
    //hook for failed test case
    public func testCase(_ testCase: XCTestCase, didFailWithDescription description: String, inFile filePath: String?, atLine lineNumber: Int) {
        print("test case \(testCase.name) failed")
        
        if(UITM.attachScreenShot!) {
            let imagePath = NSTemporaryDirectory() + ProcessInfo.processInfo.globallyUniqueString + ".png"
            let imageURL = URL(fileURLWithPath: imagePath)
            
            takeScreenShot(fileURL:imageURL )
            let s3address = S3Service.uploadImage(bucketName: UITM.S3BucketName!, imageURL: imageURL)
            testCase.metaData.failureMessage = "<br>\(description)<br/><img src='\(s3address)'>"
        }
    }
    
}
