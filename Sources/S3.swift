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

public protocol S3Protocol {
    static func authenticate(identityPoolId: String, regionType:AWSRegionType)
    static func uploadImage(bucketName:String, imageURL: URL) throws -> String
}

class S3 : S3Protocol {
    
    //authtnticate using aws cognito
    //depends on: AWSCognitoCredentialsProvider, AWSServiceConfiguration, AWSServiceManager
    static func authenticate(identityPoolId: String, regionType:AWSRegionType) {
        let credentialsProvider = AWSCognitoCredentialsProvider(regionType: regionType,identityPoolId:identityPoolId)
        let configuration = AWSServiceConfiguration(region:regionType, credentialsProvider:credentialsProvider)
        AWSServiceManager.default().defaultServiceConfiguration = configuration
    }

    //upload image to s3 bucket
    //depends on: AWSS3TransferManagerUploadRequest, AWSS3TransferManager, AWSExecutor
    static func uploadImage(bucketName:String, imageURL: URL) throws -> String {
        var uploadError:Error?
        var imageS3Address = ""
        
        var uploadRequest = AWSS3TransferManagerUploadRequest()!
        uploadRequest = makeUploadRequest(bucketName: bucketName, imageURL: imageURL, uploadRequest: uploadRequest)
        
        let transferManager = AWSS3TransferManager.default()
        let expectation = XCTestExpectation(description: "upload image to s3")
        transferManager.upload(uploadRequest).continueWith(executor: AWSExecutor.mainThread()) { (task) -> Any? in

                if let error = task.error {
                    print("S3 uploading failed with error: \(error)")
                    uploadError = error
                }
                else {
                    print("S3 uploaded succesfully")
                    imageS3Address = "https://s3.amazonaws.com/\(bucketName)/\(uploadRequest.key!)"
                }
                
                expectation.fulfill()
                return nil
        }

        XCTWaiter.wait(for: [expectation], timeout: 10.0)
        if let error = uploadError {
            throw error
        }
        return imageS3Address
    }
    
    private static func makeUploadRequest(bucketName:String, imageURL: URL, uploadRequest: AWSS3TransferManagerUploadRequest) -> AWSS3TransferManagerUploadRequest {
        
        let imageName = imageURL.path.replacingOccurrences(of: "(.*)/", with: "", options: .regularExpression, range:nil)
        let imageType = imageURL.path.replacingOccurrences(of: "(.*).", with: "", options: .regularExpression, range:nil)
        uploadRequest.bucket = bucketName
        uploadRequest.key = imageName
        uploadRequest.body = imageURL
        uploadRequest.contentType = "image/\(imageType)"
        return uploadRequest
    }
    
}
