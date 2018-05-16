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
<<<<<<< HEAD
    
    public static var shared = TMObserver()
    
    // hoook for pre-test setup
    public func testBundleWillStart(_ testBundle: Bundle){
        //authtnticate using aws cognito
        S3.authenticate(identityPoolId: UITM.S3CognitoKey!, regionType: UITM.S3RegionType!)
    }

    //hook for test finished
    public func testCaseDidFinish(_ testCase: XCTestCase) {
        print("test case Finished")
        let testStatus =  (testCase.testRun?.hasSucceeded)! ? UITM.ATMStatuses!.pass : UITM.ATMStatuses!.fail
        let testDuration = Int(testCase.testRun?.testDuration as! Double * 10000)
        let comments = "<br>\(testCase.metaData.comments)<br/>" + testCase.metaData.failureMessage
        
        //post test results to ATM
        ATM.postTestResult(testRunKey: UITM.testRunKey!, testCaseKey: testCase.metaData.testID!, testStatus: testStatus, environment: UITM.ATMENV!, comments: comments, exedutionTime: testDuration)
=======

//    public class var shared = TMObserver()
    
    // hoook for pre-test setup
//    public func testBundleWillStart(_ testBundle: Bundle){
//        //authtnticate using aws cognito
//        S3.authenticate(identityPoolId: UITM.S3CognitoKey!, regionType: UITM.S3RegionType!)
//
//    }

    public func testCaseDidFinish(_ testCase: XCTestCase) {
        print("test case Finished")
        let testStatus = (testCase.testRun?.hasSucceeded)! ? ATM.TestStatus.pass : ATM.TestStatus.fail
        let testName = testCase.name
        let testCaseKey = testCase.testID
        let testDuration = Int(testCase.testRun?.testDuration as! Double * 1000)
        
        //post test results to ATM
        ATM.postTestResult(testRunKey: UITM.testRunKey!, testCaseKey: testCaseKey, testStatus: testStatus, environment: "Mobile iOS", comments: testCase.testComments, exedutionTime: testDuration)
>>>>>>> 261e9ab6d25ed3c180c0fac297ce298102a218bb
    }
    
    //hook for failed test case
    public func testCase(_ testCase: XCTestCase, didFailWithDescription description: String, inFile filePath: String?, atLine lineNumber: Int) {
        print("test case failed")
        let imageURL = takeScreenShot()
        let s3address = S3.uploadImage(bucketName: UITM.S3BuecktName!, imageURL: imageURL)
<<<<<<< HEAD
        testCase.metaData.failureMessage = "<br>\(description)<br/><img src='\(s3address)'>"
    }
    
=======
        testCase.testComments = "<br>\(description)<br/><img src='\(s3address)'>"
    }
    
    private func takeScreenShot() -> URL {
        let screenShot: XCUIScreenshot = XCUIScreen.main.screenshot()
        let myImage = screenShot.pngRepresentation
        let fileName = ProcessInfo.processInfo.globallyUniqueString + ".png"
        let fileURL = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(fileName)
        do {
            try myImage.write(to: fileURL, options: .atomic)
        } catch {
            XCTAssert(false, "Was not able to save screen capture!")
        }
        return fileURL
    }

>>>>>>> 261e9ab6d25ed3c180c0fac297ce298102a218bb
}
