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

public protocol CloudStorage {
    func authenticate()
    func uploadImage(imageURL: URL) throws -> String
}

public class S3 : CloudStorage {
    
    var cognitoKey: String
    var regionType: AWSRegionType
    var bucketName: String
    
    init(cognitoKey:String = "", regionType:AWSRegionType = .USEast1, bucketName:String = "") {
        self.cognitoKey = cognitoKey
        self.regionType = regionType
        self.bucketName = bucketName
    }
    
    //authtnticate using aws cognito
    //depends on: AWSCognitoCredentialsProvider, AWSServiceConfiguration, AWSServiceManager
    public func authenticate() {
        let credentialsProvider = AWSCognitoCredentialsProvider(regionType: regionType, identityPoolId: cognitoKey)
        let configuration = AWSServiceConfiguration(region:regionType, credentialsProvider:credentialsProvider)
        AWSServiceManager.default().defaultServiceConfiguration = configuration
    }

    //upload image to s3 bucket
    //depends on: AWSS3TransferManagerUploadRequest, AWSS3TransferManager, AWSExecutor
    public func uploadImage(imageURL: URL) throws -> String {
        var uploadError:Error?
        var imageS3Address = ""
        
        var uploadRequest = AWSS3TransferManagerUploadRequest()!
        uploadRequest = makeUploadRequest(imageURL: imageURL, uploadRequest: uploadRequest)
        
        let transferManager = AWSS3TransferManager.default()
        let expectation = XCTestExpectation(description: "upload image to s3")
        transferManager.upload(uploadRequest).continueWith(executor: AWSExecutor.mainThread()) { (task) -> Any? in

                if let error = task.error {
                    print("S3 uploading failed with error: \(error)")
                    uploadError = error
                }
                else {
                    print("S3 uploaded succesfully")
                    imageS3Address = "https://s3.amazonaws.com/\(self.config.bucketName)/\(uploadRequest.key!)"
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
    
    private func makeUploadRequest(imageURL: URL, uploadRequest: AWSS3TransferManagerUploadRequest) -> AWSS3TransferManagerUploadRequest {
        
        let imageName = imageURL.path.replacingOccurrences(of: "(.*)/", with: "", options: .regularExpression, range:nil)
        let imageType = imageURL.path.replacingOccurrences(of: "(.*).", with: "", options: .regularExpression, range:nil)
        uploadRequest.bucket = bucketName
        uploadRequest.key = imageName
        uploadRequest.body = imageURL
        uploadRequest.contentType = "image/\(imageType)"
        return uploadRequest
    }
    
}
