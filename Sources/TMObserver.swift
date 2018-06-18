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

enum InitError:Error{
    case noCloudService
}

public class TMObserver : NSObject, XCTestObservation  {
    
    var TMService: TestManagement
    var CSService: CloudStorage?
    var attachScreenShot: Bool
    var logPath: String

   public init(TMService: TestManagement, attachScreenShot:Bool, CSService:CloudStorage?, logPath:String = "./UITM/output") throws {
        self.TMService = TMService
        self.CSService = CSService
        self.attachScreenShot = attachScreenShot
        self.logPath = logPath
    
        if attachScreenShot{
            guard CSService != nil else {
                throw InitError.noCloudService
            }
        }
    }
    
    public func testSuiteWillStart(_ testSuite: XCTestSuite) {
        print("test suite \(testSuite.name) will start.")
        
        //authtnticate cloud storage service
        if(attachScreenShot) {
            CSService!.authenticate()
        }
    }

    //hook for test finished
    public func testCaseDidFinish(_ testCase: XCTestCase) {
        print("test case \(testCase.name) Finished")
        
        let testStatus =  (testCase.testRun?.hasSucceeded)!
        let testDuration = testCase.testRun?.testDuration
        testCase.metaData.comments = "<br>\(testCase.metaData.comments)<br/>" + testCase.metaData.failureMessage
        
        let response = TMService.uploadTestResult(testId:testCase.metaData.testID, testComments:testCase.metaData.comments, testStatus:testStatus, testDuration:testDuration!)
        
        if response.result.isSuccess {
            appendToLog("Upload result successed for test case: \(testCase.metaData.testID)!")
        } else{
            appendToLog("Upload result failed with error: \(response.error!)!")
            appendToLog("Result for testcase \(testCase.metaData.testID) failed to upload!")
        }
    }
    
    //hook for failed test case
    public func testCase(_ testCase: XCTestCase, didFailWithDescription description: String, inFile filePath: String?, atLine lineNumber: Int) {
        
        print("test case \(testCase.name) failed")
        testCase.metaData.failureMessage = "<br>\(description)<br/>"
        
        //if choose to attach screen shot, then take screenshot and upload to cloud storage
        if(attachScreenShot) {
            let imagePath = NSTemporaryDirectory() + ProcessInfo.processInfo.globallyUniqueString + ".png"
            let imageURL = URL(fileURLWithPath: imagePath)
            takeScreenShot(fileURL:imageURL)
            
            do {
                let CSAddress = try CSService!.uploadImage(imageURL: imageURL)
                testCase.metaData.failureMessage += "<img src='\(CSAddress)'>"
            }
            catch {
                appendToLog("S3 upload image failed with \(error)!")
            }
        }
    }
    
    private func appendToLog(_ content: String) {
        let url = URL(fileURLWithPath: logPath).appendingPathComponent("log")
        let data = Data(content.utf8)
        do {
            try data.write(to: url, options: .atomic)
        } catch {
            print(error)
        }
    }
    
    private func takeScreenShot(fileURL: URL) {
        let screenShot: XCUIScreenshot = XCUIScreen.main.screenshot()
        let myImage = screenShot.pngRepresentation
        do {
            try myImage.write(to: fileURL, options: .atomic)
        } catch {
            XCTAssert(false, "Was not able to save screen captured!")
        }
    }

}
