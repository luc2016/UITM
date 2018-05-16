//
//  Extension.swift
//  UITM
//
//  Created by Lu Cui (LCL) on 2018-04-17.
//

import XCTest

public struct MetaData {
<<<<<<< HEAD
    static var shared = MetaData()
    
    public var testID: String?
    public var comments: String = ""
    var failureMessage: String = ""
}

public extension XCTestCase {
    
    public var metaData: MetaData {
        get {
            guard let value = objc_getAssociatedObject(self, &MetaData.shared) as? MetaData else {
                return MetaData.shared
=======
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
>>>>>>> 261e9ab6d25ed3c180c0fac297ce298102a218bb
            }
            return value
        }
        set {
<<<<<<< HEAD
            objc_setAssociatedObject(self, &MetaData.shared, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
=======
            objc_setAssociatedObject(self, &MetaData.testComments, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
>>>>>>> 261e9ab6d25ed3c180c0fac297ce298102a218bb
        }
    }

}
