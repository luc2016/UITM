//
//  File.swift
//  UITM
//
//  Created by Lu Cui (LCL) on 2018-05-11.
//

import Foundation
import AWSS3
import AWSCognito

public class UITM {

    static var ATMBaseURL: String?
    static var ATMCredential:String?
    static var ATMStatuses: (pass:String, fail:String)?
    static var ATMENV: String?
    static var S3CognitoKey: String?
    static var S3RegionType: AWSRegionType?
    static var S3BuecktName: String?
    static var testRunKey: String?

    public class func config(
            testRunKey: String,
            ATMBaseURL:String = "https://jira.lblw.ca/rest/atm/1.0",
            ATMCredential: String,
            ATMStatuses: (pass:String, fail:String) = (pass:"Pass", fail:"Fail"),
            ATMENV:String?,
            S3CognitoKey: String,
            S3RegionType:AWSRegionType,
            S3BucketName: String) {

        UITM.testRunKey = testRunKey
        UITM.ATMBaseURL = ATMBaseURL
        UITM.ATMCredential = ATMCredential
        UITM.ATMENV = ATMENV
        UITM.ATMStatuses = ATMStatuses
        UITM.S3CognitoKey = S3CognitoKey
        UITM.S3RegionType = S3RegionType
        UITM.S3BuecktName = S3BucketName
                
    }
}
