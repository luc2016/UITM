//
//  Extension.swift
//  UITM
//
//  Created by Lu Cui (LCL) on 2018-04-17.
//

import XCTest


public struct MetaData {
    static var testID: String = ""
}

public extension XCTestCase {
    
    var metaData: String {
        
        get {
            guard let value = objc_getAssociatedObject(self, &MetaData.testID) as? String else {
                return "none"
            }
            return value
        }
        set(newValue) {
            objc_setAssociatedObject(self, &MetaData.testID, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
}
