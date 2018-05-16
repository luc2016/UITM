//
//  Extension.swift
//  UITM
//
//  Created by Lu Cui (LCL) on 2018-04-17.
//

import XCTest

public struct MetaData {
    static var shared = MetaData()
    var testID: String?
    var testComments: String?
    var testStatus: String?
}

public extension XCTestCase {
    
    var metaData: MetaData {
        get {
            guard let value = objc_getAssociatedObject(self, &MetaData.shared) as? MetaData else {
                return MetaData.shared
            }
            return value
        }
        set {
            objc_setAssociatedObject(self, &MetaData.shared, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

}
