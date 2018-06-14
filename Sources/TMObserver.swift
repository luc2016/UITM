//
//  TMObserver.swift
//  XCUI_UITM
//
//  Created by Lu Cui (LCL) on 2018-04-17.
//  Copyright © 2018 lcl. All rights reserved.
//

import Foundation
import XCTest
import Alamofire
import Alamofire_Synchronous

struct ATMRequest {
    let url: String
    let headers: [String:String]
    let entries: [String:Any]
}

public protocol SessionManagerProtocol {
    func jsonResponse(_ url: URLConvertible, method: HTTPMethod, parameters: Parameters?, headers: HTTPHeaders?) -> DataResponse<Any>
}

extension Alamofire.SessionManager : SessionManagerProtocol {
    public func jsonResponse(_ url: URLConvertible, method: HTTPMethod, parameters: Parameters?, headers: HTTPHeaders?) -> DataResponse<Any> {
        return self.request(url, method: method, parameters: parameters, encoding: JSONEncoding.default, headers: headers).validate().responseJSON()
    }
}

public class TMObserver : NSObject, XCTestObservation  {
    
    var sessionManager: SessionManagerProtocol
    var S3Service: S3Protocol.Type
    
    init(sessionManager: SessionManagerProtocol = Alamofire.SessionManager.default, S3Type:S3Protocol.Type = S3.self ) {
        self.sessionManager = sessionManager
        S3Service = S3Type
    }
    
    public func testSuiteWillStart(_ testSuite: XCTestSuite) {
        print("test suite \(testSuite.name) will start.")
        
        //authtnticate using aws cognito
        if(UITM.attachScreenShot!) {
            S3Service.authenticate(identityPoolId: UITM.S3CognitoKey!, regionType: UITM.S3RegionType!)
        }
    }

    //hook for test finished
    public func testCaseDidFinish(_ testCase: XCTestCase) {
        print("test case \(testCase.name) Finished")
        
        let request = makeATMRequest(testCase)
        let response = sessionManager.jsonResponse(request.url, method: .post, parameters: request.entries, headers: request.headers)
        if let error = response.error {
            appendToLog("ATM upload result failed with error: \(error)!")
            appendToLog("The faile testcase is: \(response.request!.description)!")
        }
    }
    
    //hook for failed test case
    public func testCase(_ testCase: XCTestCase, didFailWithDescription description: String, inFile filePath: String?, atLine lineNumber: Int) {
        print("test case \(testCase.name) failed")
        
        if(UITM.attachScreenShot!) {
            let imagePath = NSTemporaryDirectory() + ProcessInfo.processInfo.globallyUniqueString + ".png"
            let imageURL = URL(fileURLWithPath: imagePath)
            testCase.metaData.failureMessage = "<br>\(description)<br/>"
            
            takeScreenShot(fileURL:imageURL )
            
            do {
                let s3address = try S3Service.uploadImage(bucketName: UITM.S3BucketName!, imageURL: imageURL)
                testCase.metaData.failureMessage += "<img src='\(s3address)'>"
            }
            catch {
                appendToLog("S3 upload image failed with \(error)!")
            }
        }
    }
    
    private func makeATMRequest(_ testCase: XCTestCase, testRunKey:String = UITM.testRunKey!, ATMBaseURL:String = UITM.ATMBaseURL!, ATMCredential: String = UITM.ATMCredential!, ATMEnv:String = UITM.ATMENV!, ATMStatus:(pass:String, fail:String) = UITM.ATMStatuses! ) -> ATMRequest {
        
        let url = "\(ATMBaseURL)/testrun/\(testRunKey)/testcase/\(testCase.metaData.testID!)/testresult"
        let headers = ["authorization": "Basic " + ATMCredential]
        
        let testStatus =  (testCase.testRun?.hasSucceeded)! ? ATMStatus.pass : ATMStatus.fail
        let testDuration = Int(testCase.testRun?.testDuration as! Double * 1000)
        let comments = "<br>\(testCase.metaData.comments)<br/>" + testCase.metaData.failureMessage
        
        let entries = [
            "status"        : testStatus,
            "environment"   : ATMEnv,
            "comment"       : comments,
            "executionTime" : testDuration
            ] as [String : Any]
        
        return  ATMRequest(url: url, headers: headers, entries: entries)
    }
    
    private func appendToLog(path: String = UITM.logPath!, _ content: String) {
        let url = URL(fileURLWithPath: path).appendingPathComponent("log")
        let data = Data(content.utf8)
        do {
            try data.write(to: url, options: .atomic)
        } catch {
            print(error)
        }
    }

}
