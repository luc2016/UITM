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
    
    public init(sessionManager: SessionManagerProtocol = Alamofire.SessionManager.default, S3Type:S3Protocol.Type = S3.self){
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
        let request = constructRequest(testCase)
        
        //post test results to ATM
        let response = sessionManager.jsonResponse(request.url, method: .post, parameters: request.entries, headers: request.headers)
//        let response = ATM(sessionManager).postTestResult(testRunKey: UITM.testRunKey!, testCaseKey: testCase.metaData.testID!, testStatus: testStatus, environment: UITM.ATMENV!, comments: comments, exedutionTime: testDuration)
        errorHandling(response)

    }
    
    //hook for failed test case
    public func testCase(_ testCase: XCTestCase, didFailWithDescription description: String, inFile filePath: String?, atLine lineNumber: Int) {
        print("test case \(testCase.name) failed")
        
        if(UITM.attachScreenShot!) {
            let imagePath = NSTemporaryDirectory() + ProcessInfo.processInfo.globallyUniqueString + ".png"
            let imageURL = URL(fileURLWithPath: imagePath)
            
            takeScreenShot(fileURL:imageURL )
            let s3address = S3Service.uploadImage(bucketName: UITM.S3BucketName!, imageURL: imageURL)
            testCase.metaData.failureMessage = "<br>\(description)<br/><img src='\(s3address)'>"
        }
    }
    
    private func constructRequest(_ testCase: XCTestCase) -> ATMRequest{
        
        let url = "\(UITM.ATMBaseURL!)/testrun/\(UITM.testRunKey)/testcase/\(testCase.metaData.testID)/testresult"
        let headers = ["authorization": "Basic "+UITM.ATMCredential!]
        
        let testStatus =  (testCase.testRun?.hasSucceeded)! ? UITM.ATMStatuses!.pass : UITM.ATMStatuses!.fail
        let testDuration = Int(testCase.testRun?.testDuration as! Double * 10000)
        let comments = "<br>\(testCase.metaData.comments)<br/>" + testCase.metaData.failureMessage
        
        let entries = [
            "status"        : testStatus,
            "environment"   : UITM.ATMENV,
            "comment"       : comments,
            "executionTime": testDuration
            ] as [String : Any]
        
        return  ATMRequest(url: url, headers: headers, entries: entries)
    }
    
    private func errorHandling(_ response: DataResponse<Any>){
        if let error = response.error{
            print("Failed with error: \(error)")
            //            logFailedResults(fileName:"ErrorLog.txt",content: url)
        }else{
            print("Uploaded test result successfully")
        }
    }
    
    private func logFailedResults(fileName:String,content: String) {
        
        let url = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(fileName)
        let data = Data(content.utf8)
        do {
            try data.write(to: url, options: .atomic)
        } catch {
            print(error)
        }
    }

}
