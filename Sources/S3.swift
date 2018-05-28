//
//  S3.swift
//  UITMTests
//
//  Created by Lu Cui (LCL) on 2018-05-05.
//  Copyright © 2018 lcl. All rights reserved.
//

import Foundation
import AWSS3
import AWSCognito
import XCTest

protocol S3Protocol {
    static func authenticate(identityPoolId: String, regionType:AWSRegionType)
    static func uploadImage(bucketName:String, imageURL: URL) -> String
}

public class S3 : S3Protocol {
    
    //authtnticate using aws cognito
    public static func authenticate(identityPoolId: String, regionType:AWSRegionType) {
        let credentialsProvider = AWSCognitoCredentialsProvider(regionType: regionType,
                                                                identityPoolId:identityPoolId)
        let configuration = AWSServiceConfiguration(region:regionType, credentialsProvider:credentialsProvider)
        AWSServiceManager.default().defaultServiceConfiguration = configuration
    }

    //upload image to s3 bucket
    public static func uploadImage(bucketName:String, imageURL: URL) -> String {

        let uploadRequest = AWSS3TransferManagerUploadRequest()!
        var imageS3Address = ""
        let imageName = imageURL.path.replacingOccurrences(of: "(.*)/", with: "", options: .regularExpression, range:nil)
        let imageType = imageURL.path.replacingOccurrences(of: "(.*).", with: "", options: .regularExpression, range:nil)
        uploadRequest.bucket = bucketName
        uploadRequest.key = imageName
        uploadRequest.body = imageURL
        uploadRequest.contentType = "image/\(imageType)"
        
        let transferManager = AWSS3TransferManager.default()
        let expectation = XCTestExpectation(description: "upload image to s3")
            transferManager.upload(uploadRequest).continueWith(executor: AWSExecutor.mainThread()) { (task) -> Any? in

                    if let error = task.error {
                        print(error)
                        fatalError("S3 uploading failed with error: \(error)")
                    }
                    
                    if task.result != nil {
                        print("uploaded succesfully")
                        imageS3Address = "https://s3.amazonaws.com/\(bucketName)/\(imageName)"
                    }
                
                expectation.fulfill()
                return nil
            }

        XCTWaiter.wait(for: [expectation], timeout: 10.0)
        return imageS3Address
    }
    
}
