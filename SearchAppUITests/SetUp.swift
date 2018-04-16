//
//  Main.swift
//  SearchAppUITests
//
//  Created by Lu Cui (LCL) on 2018-05-13.
//  Copyright © 2018 lcl. All rights reserved.
//

import Foundation
import XCTest

 let observer = TestObserver()

class SetUp : NSObject {
    override init() {
        UITM.config(
            ATMBaseURL:     "https://jira.lblw.ca/rest/atm/1.0",
            ATMCredential:  "Basic RmVycmlzOmZlcnJpcw==",
            ATMCustomStatus:[],
            S3CognitoKey:    "us-east-1:738ab02b-76f4-4d6c-87ef-e8847f97f6cd",
            S3RegionType:   .USEast1,
            S3BucketName:   "uitm2",
            testRunKey:     ProcessInfo.processInfo.environment["TEST_RUN_KEY"]!
        )

        XCTestObservationCenter.shared.addTestObserver(TestObserver.shared)
    }

}
