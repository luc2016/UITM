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

public class S3 {
    
    public static func uploadImage(bucketName:String, imageURL: URL) -> String {

<<<<<<< HEAD
=======

>>>>>>> 261e9ab6d25ed3c180c0fac297ce298102a218bb
        let uploadRequest = AWSS3TransferManagerUploadRequest()!
        var imageS3Address = ""
        let imageName = imageURL.path.replacingOccurrences(of: "(.*)/", with: "", options: .regularExpression, range:nil)
        uploadRequest.bucket = bucketName
        uploadRequest.key = imageName
        uploadRequest.body = imageURL
        uploadRequest.contentType = "image/png"
        
        let transferManager = AWSS3TransferManager.default()
        let expectation = XCTestExpectation(description: "upload image to s3")
            transferManager.upload(uploadRequest).continueWith(executor: AWSExecutor.mainThread()) { (task) -> Any? in

                    if let error = task.error {
                        print(error)
<<<<<<< HEAD
                        fatalError("S3 uploading failed with error: \(error)")
=======
>>>>>>> 261e9ab6d25ed3c180c0fac297ce298102a218bb
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
    
    //authtnticate using aws cognito
    static func authenticate(identityPoolId: String, regionType:AWSRegionType) {
        let credentialsProvider = AWSCognitoCredentialsProvider(regionType: regionType,
                                                                identityPoolId:identityPoolId)
        let configuration = AWSServiceConfiguration(region:regionType, credentialsProvider:credentialsProvider)
        AWSServiceManager.default().defaultServiceConfiguration = configuration
    }
    
}
