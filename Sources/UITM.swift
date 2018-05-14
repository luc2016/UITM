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

    static var ATMBaseURL: String = "https://jira.lblw.ca/rest/atm/1.0"
    static var ATMCredentials:String = "Basic RmVycmlzOmZlcnJpcw=="
    static var ATMCustomStatus: [String] = []
    static var S3CognitoKey: String?
    static var S3RegionType: AWSRegionType?
    static var S3BuecktName: String?
    static var testRunKey: String?


    class func config(ATMBaseURL:String?, ATMCredential: String, ATMCustomStatus: [String] = [], S3CognitoKey: String, S3RegionType:AWSRegionType, S3BucketName: String, testRunKey: String) {

        UITM.ATMBaseURL = ATMBaseURL!
        UITM.ATMCredentials = ATMCredentials
        UITM.ATMCustomStatus = ATMCustomStatus
        UITM.S3CognitoKey = S3CognitoKey
        UITM.S3RegionType = S3RegionType
        UITM.S3BuecktName = S3BucketName
        UITM.testRunKey = testRunKey
        
        //authtnticate to S3 using aws cognito
        S3.authenticate(identityPoolId: S3CognitoKey, regionType: S3RegionType)

    }

}
