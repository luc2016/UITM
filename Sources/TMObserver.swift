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
import Alamofire_Synchronous



public class TMObserver : NSObject, XCTestObservation  {
    
//    var TMService: TestManagement
//    var CSService: CloudStorage
//
//    init(TM: TestManagement = UITM.TMService!, CS:CloudStorage = UITM.CSService! ) {
//        TMService = TM
//        CSService = CS
//    }
    
    var TMService = UITM.TMService!
    var CSService = UITM.CSService!

    
    public func testSuiteWillStart(_ testSuite: XCTestSuite) {
        print("test suite \(testSuite.name) will start.")
        
        //authtnticate cloud storage service
        if(UITM.attachScreenShot!) {
            CSService.authenticate()
        }
    }

    //hook for test finished
    public func testCaseDidFinish(_ testCase: XCTestCase) {
        print("test case \(testCase.name) Finished")
        
        let testStatus =  (testCase.testRun?.hasSucceeded)!
        let testDuration = testCase.testRun?.testDuration
        let comments = "<br>\(testCase.metaData.comments)<br/>" + testCase.metaData.failureMessage
        
        let response = TMService.uploadTestResult(testId:testCase.metaData.testID!, testComments:comments, testStatus:testStatus, testDuration:testDuration!)
        if let error = response.error {
            appendToLog("Upload result failed with error: \(error)!")
            appendToLog("The faile testcase is: \(response.request!.description)!")
        }
    }
    
    //hook for failed test case
    public func testCase(_ testCase: XCTestCase, didFailWithDescription description: String, inFile filePath: String?, atLine lineNumber: Int) {
        
        print("test case \(testCase.name) failed")
        testCase.metaData.failureMessage = "<br>\(description)<br/>"
        
        //if choose to attach screen shot, then take screenshot and upload to cloud storage
        if(UITM.attachScreenShot!) {
            let imagePath = NSTemporaryDirectory() + ProcessInfo.processInfo.globallyUniqueString + ".png"
            let imageURL = URL(fileURLWithPath: imagePath)
            takeScreenShot(fileURL:imageURL )
            
            do {
                let s3address = try CSService.uploadImage(imageURL: imageURL)
                testCase.metaData.failureMessage += "<img src='\(s3address)'>"
            }
            catch {
                appendToLog("S3 upload image failed with \(error)!")
            }
        }
    }
    
    private func appendToLog(path: String = UITM.logPath!, _ content: String) {
        let url = URL(fileURLWithPath: path).appendingPathComponent("log")
        let data = Data(content.utf8)
        do {
            try data.write(to: url, options: .atomic)
        } catch {
            print(error)
        }
    }

}
