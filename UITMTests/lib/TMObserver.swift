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
        let des = testCase.testRun?.description
        let testCaseKey = testCase.testID
        
        let image:Data?
        //post test results to ATM
        if !testStatus! {
            image = takeScreenShot()
            ATM.postTestResult(testRunKey: testRunKey, testCaseKey: testCaseKey, testStatus: testStatus!,attachment:image!)
        }
        else {
            ATM.postTestResult(testRunKey: testRunKey, testCaseKey: testCaseKey, testStatus: testStatus!,attachment:nil)
        }
        
    }
    
    private func takeScreenShot() -> Data{
        let screenShot: XCUIScreenshot = XCUIScreen.main.screenshot()
        let myImage = screenShot.pngRepresentation
        let url = URL(fileURLWithPath: "testVRNavigatingToMainCategory.png")
        do {
            try myImage.write(to: url, options: .atomic)
        } catch {
            XCTAssert(false, "Was not able to save screen capture!")
        }
        return myImage
    }

}
