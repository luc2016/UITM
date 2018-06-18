//
//  ConfigTests.swift
//  SearchAppUITests
//
//  Created by Lu Cui (LCL) on 2018-05-25.
//  Copyright © 2018 lcl. All rights reserved.
//

import XCTest

class TMObserverInitTests: XCTestCase {
    
    override func setUp() {
        continueAfterFailure = false
    }

    func testInitTMObserverWithScreenShot() {

        let atm = ATM(
            baseURL:    "https://jira.lblw.ca/rest/atm/1.0",
            credentials:"ZmVycmlzOmZlcnJpcw==",
            env:        "Mobile iOS",
            testRunKey: "GOLM-R13",
            statuses:   (pass: "Pass", fail: "Fail")
        )

        let s3 = S3(
            cognitoKey: "us-east-1:738ab02b-76f4-4d6c-87ef-e8847f97f6cd",
            regionType: .USEast1,
            bucketName: "uitm2"
        )
        
        XCTAssertNoThrow(try TMObserver(TMService: atm, attachScreenShot:true, CSService: s3, logPath: "./output")
, "Observer init shoudn't throw an error")

        let observer = try! TMObserver(TMService: atm, attachScreenShot:true, CSService: s3, logPath: "./output")
        let tmService = observer.TMService as! ATM
        let csService = observer.CSService as! S3
        XCTAssertEqual(tmService.testRunKey,    "GOLM-R13", "Test Run key is not set properly.")
        XCTAssertEqual(tmService.baseURL,       "https://jira.lblw.ca/rest/atm/1.0", "ATM base url is not set properly.")
        XCTAssertEqual(tmService.credentials,   "ZmVycmlzOmZlcnJpcw==", "ATM credential is not set properly.")
        XCTAssertEqual(tmService.env,           "Mobile iOS", "ATM environment is not set properly.")
        XCTAssertEqual(observer.attachScreenShot,  true, "Attach screen shot is not set properly.")
        XCTAssertEqual(csService.cognitoKey,    "us-east-1:738ab02b-76f4-4d6c-87ef-e8847f97f6cd", "Attach screen shot is not set properly.")
        XCTAssertEqual(csService.regionType,    .USEast1, "Attach screen shot is not set properly.")
        XCTAssertEqual(csService.bucketName,    "uitm2", "Attach screen shot is not set properly.")
        XCTAssertEqual(observer.logPath,        "./output", "log path is not set properly.")
    }

    //test if attachmentScreenshot is false, and no cloud storage is set
    func testInitTMObserverWithoutScreenShot() {

        let atm = ATM(
            baseURL:    "https://jira.lblw.ca/rest/atm/1.0",
            credentials:"ZmVycmlzOmZlcnJpcw==",
            env:        "Mobile iOS",
            testRunKey: "GOLM-R13",
            statuses:   (pass: "Pass", fail: "Fail")
        )
        
        XCTAssertNoThrow(try TMObserver(TMService: atm, attachScreenShot: false, CSService: nil), "Observer init shoudn't throw error")

        let observer = try! TMObserver(TMService: atm, attachScreenShot: false,CSService: nil)
        let tmService = observer.TMService as! ATM
        XCTAssertEqual(tmService.testRunKey,    "GOLM-R13", "Test Run key is not set properly.")
        XCTAssertEqual(tmService.baseURL,       "https://jira.lblw.ca/rest/atm/1.0", "ATM base url is not set properly.")
        XCTAssertEqual(tmService.credentials,   "ZmVycmlzOmZlcnJpcw==", "ATM credential is not set properly.")
        XCTAssertEqual(tmService.env,           "Mobile iOS", "ATM environment is not set properly.")
        XCTAssertEqual(observer.attachScreenShot,   false, "Attach screen shot is not set properly.")
        XCTAssertEqual(observer.logPath,            "./UITM/output", "log path is not set properly.")
    }

    //test if attachmentScreenshot is false, and no cloud storage is set, then init will throw an error
    func testConfigurationWithScreenShotAndNoCS() {

        let atm = ATM(
            baseURL:    "https://jira.lblw.ca/rest/atm/1.0",
            credentials:"ZmVycmlzOmZlcnJpcw==",
            env:        "Mobile iOS",
            testRunKey: "GOLM-R13",
            statuses:   (pass: "Pass", fail: "Fail")
        )

        XCTAssertThrowsError(try TMObserver(TMService: atm, attachScreenShot: true,CSService: nil), "Observer init should throw config error") { (error) in
            XCTAssertEqual(error as! InitError, InitError.noCloudService, "Observer init should throw config error")
        }

    }

}
