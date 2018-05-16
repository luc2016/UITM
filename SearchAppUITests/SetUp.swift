//
//  Main.swift
//  SearchAppUITests
//
//  Created by Lu Cui (LCL) on 2018-05-13.
//  Copyright © 2018 lcl. All rights reserved.
//

import Foundation
import XCTest

class SetUp : NSObject {
    override init() {
        UITM.config(
            testRunKey: ProcessInfo.processInfo.environment["TEST_RUN_KEY"]!,
            ATMBaseURL:     "https://jira.lblw.ca/rest/atm/1.0",
            ATMCredential:  "Basic RmVycmlzOmZlcnJpcw==",
            ATMENV:         ProcessInfo.processInfo.environment["ATM_ENV"]!,
            S3CognitoKey:    "us-east-1:738ab02b-76f4-4d6c-87ef-e8847f97f6cd",
            S3RegionType:   .USEast1,
            S3BucketName:   "uitm2"
        )
        
        XCTestObservationCenter.shared.addTestObserver(TestObserver.shared)
    }

}
