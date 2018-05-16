//
//  Helper.swift
//  SearchAppUITests
//
//  Created by Lu Cui (LCL) on 2018-05-15.
//  Copyright © 2018 lcl. All rights reserved.
//

import Foundation
import XCTest

func takeScreenShot() -> URL {
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
