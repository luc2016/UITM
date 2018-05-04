//
//  Extension.swift
//  UITM
//
//  Created by Lu Cui (LCL) on 2018-04-17.
//

import XCTest


public struct MetaData {
    static var testID: String?
}

public extension XCTestCase {
    public typealias XCTestCaseClosure = (XCTestCase) throws -> Void
    public typealias XCTestCaseEntry = (testCaseClass: XCTestCase.Type, allTests: [(String, XCTestCaseClosure)])

    var testID: String {

        get {
            guard let value = objc_getAssociatedObject(self, &MetaData.testID) as? String else {
                return "N/A"
            }
            return value
        }
        set {
            objc_setAssociatedObject(self, &MetaData.testID, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }

    }

}

