////
////  ATM.swift
////  UITMTests
////
////  Created by Lu Cui (LCL) on 2018-04-25.
////  Copyright © 2018 lcl. All rights reserved.
////
//
//import Foundation
//import Alamofire
//import Alamofire_Synchronous
//import AWSS3
//
//public protocol SessionManagerProtocol {
//    func jsonResponse(_ url: URLConvertible, method: HTTPMethod, parameters: Parameters?, headers: HTTPHeaders?) -> DataResponse<Any>
//}
//
//extension Alamofire.SessionManager : SessionManagerProtocol {
//    public func jsonResponse(_ url: URLConvertible, method: HTTPMethod, parameters: Parameters?, headers: HTTPHeaders?) -> DataResponse<Any> {
//        return self.request(url, method: method, parameters: parameters, encoding: JSONEncoding.default, headers: headers).validate().responseJSON()
//    }
//}
//
//
//class ATM {
//    var sessionManager : SessionManagerProtocol
//    
//    init(_ sessionManager: SessionManagerProtocol = Alamofire.SessionManager.default){
//        self.sessionManager = sessionManager
//    }
//
//    public func postTestResult(testRunKey: String, testCaseKey: String, testStatus: String, environment: String, comments:String, exedutionTime: Int) -> DataResponse<Any> {
//        
//        let request = constructRequest(testRunKey: testRunKey, testCaseKey: testCaseKey, testStatus: testStatus, environment: environment, comments: comments, exedutionTime: exedutionTime)
//        let response = sessionManager.jsonResponse(request.url, method: .post, parameters: request.entries, headers: request.headers)
//
//        return response
//        
//    }
//    
//
//    
//}
