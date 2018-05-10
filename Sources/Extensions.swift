//
//  Extension.swift
//  UITM
//
//  Created by Lu Cui (LCL) on 2018-04-17.
//

import XCTest

public struct MetaData {
    static var testID: String?
    static var testComments: String?
}

public extension XCTestCase {

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
    
    var testComments: String {
        get {
            guard let value = objc_getAssociatedObject(self, &MetaData.testComments) as? String else {
                return "N/A"
            }
            return value
        }
        set {
            objc_setAssociatedObject(self, &MetaData.testComments, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

}
