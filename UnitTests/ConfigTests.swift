//
//  ConfigTests.swift
//  SearchAppUITests
//
//  Created by Lu Cui (LCL) on 2018-05-25.
//  Copyright © 2018 lcl. All rights reserved.
//

import XCTest

class ConfigTests: XCTestCase {
    
    func testConfigurationWithScreenShot() throws {
        
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

        let result = try? UITM.config(
            TMService:          atm,
            attachScreenShot:   true,
            CSService:          s3,
            logPath:            "./output"
        )

        let tmService = UITM.TMService as! ATM
        let csService = UITM.CSService as! S3
        XCTAssertEqual(tmService.testRunKey,    "GOLM-R13", "Test Run key is not set properly.")
        XCTAssertEqual(tmService.baseURL,       "https://jira.lblw.ca/rest/atm/1.0", "ATM base url is not set properly.")
        XCTAssertEqual(tmService.credentials,   "ZmVycmlzOmZlcnJpcw==", "ATM credential is not set properly.")
        XCTAssertEqual(tmService.env,           "Mobile iOS", "ATM environment is not set properly.")
        XCTAssertEqual(UITM.attachScreenShot,   true, "Attach screen shot is not set properly.")
        XCTAssertEqual(csService.cognitoKey,    "us-east-1:738ab02b-76f4-4d6c-87ef-e8847f97f6cd", "Attach screen shot is not set properly.")
        XCTAssertEqual(csService.regionType,    .USEast1, "Attach screen shot is not set properly.")
        XCTAssertEqual(csService.bucketName,    "uitm2", "Attach screen shot is not set properly.")
        XCTAssertEqual(UITM.logPath,            "./output", "log path is not set properly.")
        XCTAssertNotNil(result,                 "Config function shouldn't throw error")
    }
    
    //test if attachmentScreenshot is false, and no cloud storage is set
    func testConfigurationWithoutScreenShot() throws {
        
        let atm = ATM(
            baseURL:    "https://jira.lblw.ca/rest/atm/1.0",
            credentials:"ZmVycmlzOmZlcnJpcw==",
            env:        "Mobile iOS",
            testRunKey: "GOLM-R13",
            statuses:   (pass: "Pass", fail: "Fail")
        )

        let result = try? UITM.config(
            TMService:          atm,
            attachScreenShot:   false,
            CSService:          nil
        )

        let tmService = UITM.TMService as! ATM
        XCTAssertEqual(tmService.testRunKey,    "GOLM-R13", "Test Run key is not set properly.")
        XCTAssertEqual(tmService.baseURL,       "https://jira.lblw.ca/rest/atm/1.0", "ATM base url is not set properly.")
        XCTAssertEqual(tmService.credentials,   "ZmVycmlzOmZlcnJpcw==", "ATM credential is not set properly.")
        XCTAssertEqual(tmService.env,           "Mobile iOS", "ATM environment is not set properly.")
        XCTAssertEqual(UITM.attachScreenShot,   false, "Attach screen shot is not set properly.")
        XCTAssertEqual(UITM.logPath,            "./UITM/output", "log path is not set properly.")
        XCTAssertNotNil(result,                 "Config function shouldn't throw error")
        
    }
    
    //test if attachmentScreenshot is false, and no cloud storage is set, then config will throw an error
    func testConfigurationWithScreenShotAndNoCS() throws {
        
        let atm = ATM(
            baseURL:    "https://jira.lblw.ca/rest/atm/1.0",
            credentials:"ZmVycmlzOmZlcnJpcw==",
            env:        "Mobile iOS",
            testRunKey: "GOLM-R13",
            statuses:   (pass: "Pass", fail: "Fail")
        )
        
        let result = try? UITM.config(
            TMService:          atm,
            attachScreenShot:   true,
            CSService:          nil
        )
        
        let tmService = UITM.TMService as! ATM
        let csService = UITM.CSService as! S3
        XCTAssertEqual(tmService.testRunKey,    "GOLM-R13", "Test Run key is not set properly.")
        XCTAssertEqual(tmService.baseURL,       "https://jira.lblw.ca/rest/atm/1.0", "ATM base url is not set properly.")
        XCTAssertEqual(tmService.credentials,   "ZmVycmlzOmZlcnJpcw==", "ATM credential is not set properly.")
        XCTAssertEqual(tmService.env,           "Mobile iOS", "ATM environment is not set properly.")
        XCTAssertEqual(UITM.attachScreenShot,   true, "Attach screen shot is not set properly.")
        XCTAssertEqual(csService.cognitoKey,    "",         "cloud service is not using default value.")
        XCTAssertEqual(csService.regionType,    .USEast1,   "cloud service is not using default value.")
        XCTAssertEqual(csService.bucketName,    "",         "cloud service is not using default value.")
        XCTAssertEqual(UITM.logPath,            "./UITM/output", "log path is not using default value.")
        XCTAssertNil(result,                    "Config function should thow an error.")
    }
    
}
