//
//  ConfigTests.swift
//  SearchAppUITests
//
//  Created by Lu Cui (LCL) on 2018-05-25.
//  Copyright © 2018 lcl. All rights reserved.
//

import XCTest

class ConfigTests: XCTestCase {
    
    //test singleton variables are set properly
    func testConfigurationWithScreenShot() throws {
        
        let s3config = S3Config(
            cognitoKey: "us-east-1:738ab02b-76f4-4d6c-87ef-e8847f97f6cd",
            regionType: .USEast1,
            bucketName: "uitm2"
        )
        
        let atmConfig = ATMConfig(
            baseURL:    "https://jira.lblw.ca/rest/atm/1.0",
            credentials:"ZmVycmlzOmZlcnJpcw==",
            statuses:   (pass: "Pass", fail: "Fail"),
            env:        "Mobile iOS",
            testRunKey: "GOLM-R13"
        )
        
        UITM.config(
            TMConfig:           atmConfig,
            attachScreenShot:   true,
            CSConfig:           s3config,
            logPath:            "./output"
        )

        let tmConfig = UITM.TMConfig as! ATMConfig
        let csConfig = UITM.CSConfig as! S3Config
        XCTAssertEqual(tmConfig.testRunKey,     "GOLM-R13", "Test Run key is not set properly.")
        XCTAssertEqual(tmConfig.baseURL,        "https://jira.lblw.ca/rest/atm/1.0", "ATM base url is not set properly.")
        XCTAssertEqual(tmConfig.credentials,    "ZmVycmlzOmZlcnJpcw==", "ATM credential is not set properly.")
        XCTAssertEqual(tmConfig.env,            "Mobile iOS", "ATM environment is not set properly.")
        XCTAssertEqual(UITM.attachScreenShot,   true, "Attach screen shot is not set properly.")
        XCTAssertEqual(csConfig.cognitoKey,     "us-east-1:738ab02b-76f4-4d6c-87ef-e8847f97f6cd", "Attach screen shot is not set properly.")
        XCTAssertEqual(csConfig.regionType,     .USEast1, "Attach screen shot is not set properly.")
        XCTAssertEqual(csConfig.bucketName,     "uitm2", "Attach screen shot is not set properly.")
        XCTAssertEqual(UITM.logPath,            "./output", "log path is not set properly.")
    }
    
    //test if attachmentScreenshot is true, and no S3 parameter set, then function will throw an error
    func testConfigurationWithoutScreenShot() throws {
        
        let atmConfig = ATMConfig(
            baseURL:    "https://jira.lblw.ca/rest/atm/1.0",
            credentials:"ZmVycmlzOmZlcnJpcw==",
            statuses:   (pass: "Pass", fail: "Fail"),
            env:        "Mobile iOS",
            testRunKey: "GOLM-R13"
        )
        
        UITM.config(
            TMConfig:           atmConfig,
            attachScreenShot:   false,
            CSConfig:           S3Config()
        )
        
        let tmConfig = UITM.TMConfig as! ATMConfig
    
        XCTAssertEqual(tmConfig.testRunKey,     "GOLM-R13", "Test Run key is not set properly.")
        XCTAssertEqual(tmConfig.baseURL,        "https://jira.lblw.ca/rest/atm/1.0", "ATM base url is not set properly.")
        XCTAssertEqual(tmConfig.credentials,    "ZmVycmlzOmZlcnJpcw==", "ATM credential is not set properly.")
        XCTAssertEqual(tmConfig.env,            "Mobile iOS", "ATM environment is not set properly.")
        XCTAssertEqual(UITM.attachScreenShot,   false, "Attach screen shot is not set properly.")
        XCTAssert(UITM.CSConfig == nil, "")
        XCTAssertEqual(UITM.logPath,            "./UITM/output", "log path is not set properly.")
        
    }
    
    //test singleton variables are set properly
    func testConfigurationWithScreenShotAndNoCSConfig() throws {
        
        let atmConfig = ATMConfig(
            baseURL:    "https://jira.lblw.ca/rest/atm/1.0",
            credentials:"ZmVycmlzOmZlcnJpcw==",
            statuses:   (pass: "Pass", fail: "Fail"),
            env:        "Mobile iOS",
            testRunKey: "GOLM-R13"
        )
        let s3 = S3Config()
        
    
        
        UITM.config(
            TMConfig:           atmConfig,
            attachScreenShot:   true,
            CSConfig:           s3
        )
        
        let tmConfig = UITM.TMConfig as! ATMConfig
        let csConfig = UITM.CSConfig as! S3Config
//        XCTAssertEqual(tmConfig.testRunKey,     "GOLM-R13", "Test Run key is not set properly.")
//        XCTAssertEqual(tmConfig.baseURL,        "https://jira.lblw.ca/rest/atm/1.0", "ATM base url is not set properly.")
//        XCTAssertEqual(tmConfig.credentials,    "ZmVycmlzOmZlcnJpcw==", "ATM credential is not set properly.")
//        XCTAssertEqual(tmConfig.env,            "Mobile iOS", "ATM environment is not set properly.")
//        XCTAssertEqual(UITM.attachScreenShot,   true, "Attach screen shot is not set properly.")
//        XCTAssertEqual(csConfig.cognitoKey,     "us-east-1:738ab02b-76f4-4d6c-87ef-e8847f97f6cd", "Attach screen shot is not set properly.")
//        XCTAssertEqual(csConfig.regionType,     .USEast1, "Attach screen shot is not set properly.")
//        XCTAssertEqual(csConfig.bucketName,     "uitm2", "Attach screen shot is not set properly.")
//        XCTAssertEqual(UITM.logPath,            "./output", "log path is not set properly.")
    }
    
}
