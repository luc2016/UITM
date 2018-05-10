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

    public func testCaseDidFinish(_ testCase: XCTestCase) {
        print("test case Finished")
        let testStatus = testCase.testRun?.hasSucceeded
        let testName = testCase.name
        let testCaseKey = testCase.testID
        let testDuration = Int(testCase.testRun?.testDuration as! Double * 1000)
        
        //post test results to ATM
        ATM.postTestResult(testRunKey: testRunKey, testCaseKey: testCaseKey, testStatus: testStatus!,environment: "Mobile iOS", comments: testCase.testComments, exedutionTime: testDuration)
    }
    
    //hook for failed test case
    public func testCase(_ testCase: XCTestCase, didFailWithDescription description: String, inFile filePath: String?, atLine lineNumber: Int) {
        print("test case failed")
        let imageName = takeScreenShot()
        let s3address = S3.uploadImage(bucketName: "uitm2", imageName: imageName)
        testCase.testComments = "<br>\(description)<br/><img src='\(s3address)'>"
    }
    
    private func takeScreenShot() -> String {
        let screenShot: XCUIScreenshot = XCUIScreen.main.screenshot()
        let myImage = screenShot.pngRepresentation
        let fileName = ProcessInfo.processInfo.globallyUniqueString + ".png"
        let fileURL = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(fileName)
        do {
            try myImage.write(to: fileURL, options: .atomic)
        } catch {
            XCTAssert(false, "Was not able to save screen capture!")
        }
        return fileName
    }

}
