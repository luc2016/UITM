//
//  TMObserver.swift
//  XCUI_UITM
//
//  Created by Lu Cui (LCL) on 2018-04-17.
//  Copyright © 2018 lcl. All rights reserved.
//

import Foundation
import XCTest

public class TMObserver: NSObject, XCTestObservation {
    
    public static var shared = TMObserver()
    
    // hoook for pre-test setup
    public func testBundleWillStart(_ testBundle: Bundle){
        //authtnticate using aws cognito
        S3.authenticate(identityPoolId: UITM.S3CognitoKey!, regionType: UITM.S3RegionType!)
    }

    //hook for test finished
    public func testCaseDidFinish(_ testCase: XCTestCase) {
        print("test case Finished")
        let runResult =  (testCase.testRun?.hasSucceeded)! ? ATM.status[0] : ATM.status[1]
        let testStatus = testCase.metaData.testStatus ?? runResult
        let testDuration = Int(testCase.testRun?.testDuration as! Double * 1000)
        
        //post test results to ATM
        ATM.postTestResult(testRunKey: UITM.testRunKey!, testCaseKey: testCase.metaData.testID!, testStatus: testStatus, environment: "Mobile iOS", comments: testCase.metaData.testComments!, exedutionTime: testDuration)
    }
    
    //hook for failed test case
    public func testCase(_ testCase: XCTestCase, didFailWithDescription description: String, inFile filePath: String?, atLine lineNumber: Int) {
        print("test case failed")
        let imageURL = takeScreenShot()
        let s3address = S3.uploadImage(bucketName: UITM.S3BuecktName!, imageURL: imageURL)
        testCase.metaData.testComments = "<br>\(description)<br/><img src='\(s3address)'>"
    }
    
}
