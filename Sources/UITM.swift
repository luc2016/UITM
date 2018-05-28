//
//  File.swift
//  UITM
//
//  Created by Lu Cui (LCL) on 2018-05-11.
//

import Foundation
import AWSS3
import AWSCognito

enum ConfigError: Error {
    case nilError
}

public class UITM {

    static var ATMBaseURL: String?
    static var ATMCredential:String?
    static var ATMStatuses: (pass:String, fail:String)?
    static var ATMENV: String?
    static var attachScreenShot: Bool?
    static var S3CognitoKey: String?
    static var S3RegionType: AWSRegionType?
    static var S3BucketName: String?
    static var testRunKey: String?

    public class func config(
            testRunKey: String,
            ATMBaseURL:String = "https://jira.lblw.ca/rest/atm/1.0",
            ATMCredential: String,
            ATMStatuses: (pass:String, fail:String) = (pass:"Pass", fail:"Fail"),
            ATMENV:String,
            attachScreenShot: Bool,
            S3CognitoKey: String? = nil,
            S3RegionType: AWSRegionType? = nil,
            S3BucketName: String? = nil) throws {
        
        // if attachmentScreenShot, then s3 cognito and bucket info can't be nil
        if(attachScreenShot){
            guard S3CognitoKey != nil && S3RegionType != nil && S3BucketName != nil  else{
                throw ConfigError.nilError
            }
        }

        UITM.testRunKey = testRunKey
        UITM.ATMBaseURL = ATMBaseURL
        UITM.ATMCredential = ATMCredential
        UITM.ATMENV = ATMENV
        UITM.ATMStatuses = ATMStatuses
        UITM.attachScreenShot = attachScreenShot
        UITM.S3CognitoKey = S3CognitoKey
        UITM.S3RegionType = S3RegionType
        UITM.S3BucketName = S3BucketName
                
    }
}
