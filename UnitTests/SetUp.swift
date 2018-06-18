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

        let observer = try? TMObserver(TMService:atm, attachScreenShot:true, CSService: s3, logPath: "./UITM/output")
        XCTAssertNotNil(observer, "Observer is not initialized properly.")
//        XCTestObservationCenter.shared.addTestObserver(observer)
    }

}
