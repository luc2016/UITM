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
        
        let atmConfig = ATMConfig(
            baseURL:    "https://jira.lblw.ca/rest/atm/1.0",
            credentials:"ZmVycmlzOmZlcnJpcw==",
            statuses:   (pass: "Pass", fail: "Fail"),
            env:        "Mobile iOS",
            testRunKey: "GOLM-R13"
        )
        
        let s3 = S3(
            cognitoKey: "us-east-1:738ab02b-76f4-4d6c-87ef-e8847f97f6cd",
            regionType: .USEast1,
            bucketName: "uitm2"
        )
        
        UITM.config(
            TMConfig:           atmConfig,
            attachScreenShot:   true,
            CSService:           s3,
            logPath:            "./UITM/output"
        )
        
//        XCTestObservationCenter.shared.addTestObserver(TMObserver())
    }

}
