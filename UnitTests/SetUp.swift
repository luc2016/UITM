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
        let s3config = S3Config(
            cognitoKey: "us-east-1:738ab02b-76f4-4d6c-87ef-e8847f97f6cd",
            regionType: .USEast1,
            bucketName: "uitm2"
        )
        let s3 = S3Config()
        
        
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
            logPath:            "./UITM/output"
        )
        
//        XCTestObservationCenter.shared.addTestObserver(TMObserver())
    }

}
