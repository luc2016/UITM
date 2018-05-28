//
//  ConfigTests.swift
//  SearchAppUITests
//
//  Created by Lu Cui (LCL) on 2018-05-25.
//  Copyright © 2018 lcl. All rights reserved.
//

import XCTest

class ConfigTests: XCTestCase {
    
    func testConfigurationWithScreenShotSuccess() throws {
        
        try UITM.config(
            testRunKey:     "R13",
            ATMBaseURL:     "https://jira.lblw.ca/rest/atm/1.0",
            ATMCredential:  "Basic RmVycmlzOmZlcnJpcw==",
            ATMENV:         "Mobile iOS",
            attachScreenShot: true,
            S3CognitoKey:   "us-east-1:738ab02b-76f4-4d6c-87ef-e8847f97f6cd",
            S3RegionType:   .USEast1,
            S3BucketName:   "uitm2"
        )

        XCTAssertEqual(UITM.testRunKey,     "R13", "Test Run key is not set properly.")
        XCTAssertEqual(UITM.ATMBaseURL,     "https://jira.lblw.ca/rest/atm/1.0", "ATM base url is not set properly.")
        XCTAssertEqual(UITM.ATMCredential,  "Basic RmVycmlzOmZlcnJpcw==", "ATM credential is not set properly.")
        XCTAssertEqual(UITM.ATMENV,         "Mobile iOS", "ATM environment is not set properly.")
        XCTAssertEqual(UITM.attachScreenShot, true, "Attach screen shot is not set properly.")
        XCTAssertEqual(UITM.S3CognitoKey,   "us-east-1:738ab02b-76f4-4d6c-87ef-e8847f97f6cd", "Attach screen shot is not set properly.")
        XCTAssertEqual(UITM.S3RegionType,   .USEast1, "Attach screen shot is not set properly.")
        XCTAssertEqual(UITM.S3BucketName,   "uitm2", "Attach screen shot is not set properly.")
    }
    
    func testConfigurationWithScreenShotFail() throws {
        
        let result = try? UITM.config(
            testRunKey:     "R13",
            ATMBaseURL:     "https://jira.lblw.ca/rest/atm/1.0",
            ATMCredential:  "Basic RmVycmlzOmZlcnJpcw==",
            ATMENV:         "Mobile iOS",
            attachScreenShot: true
        )
        
        XCTAssertNil(result, "should throw error message if S3 info is not provided")
        
    }
    
    func testConfigurationNoScreenShotSuccess() throws {
        
        try UITM.config(
            testRunKey:     "R13",
            ATMCredential:  "Basic RmVycmlzOmZlcnJpcw==",
            ATMENV:         "Mobile iOS",
            attachScreenShot: false
        )
        
    }
    
}
