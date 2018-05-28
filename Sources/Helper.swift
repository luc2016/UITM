//
//  Helper.swift
//  SearchAppUITests
//
//  Created by Lu Cui (LCL) on 2018-05-15.
//  Copyright © 2018 lcl. All rights reserved.
//

import Foundation
import XCTest

public func takeScreenShot(fileURL: URL) {
    let screenShot: XCUIScreenshot = XCUIScreen.main.screenshot()
    let myImage = screenShot.pngRepresentation
    do {
        try myImage.write(to: fileURL, options: .atomic)
    } catch {
        XCTAssert(false, "Was not able to save screen captured!")
    }
}
