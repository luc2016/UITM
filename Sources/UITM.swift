//
//  File.swift
//  UITM
//
//  Created by Lu Cui (LCL) on 2018-05-11.
//

import Foundation

enum ConfigError:Error{
    case NoCloudServiceError
}

public class UITM {
    
    static var TMService: TestManagement?
    static var attachScreenShot: Bool?
    static var CSService: CloudStorage?
    static var logPath: String?
    
    public class func config(
            TMService:          TestManagement,
            attachScreenShot:   Bool,
            CSService:          CloudStorage?,
            logPath:            String = "./UITM/output"
        ) throws {
        
        UITM.TMService = TMService
        UITM.attachScreenShot = attachScreenShot
        UITM.CSService = CSService
        UITM.logPath = logPath
        
        if attachScreenShot {
            guard CSService != nil else {
                UITM.CSService = S3()
                throw ConfigError.NoCloudServiceError
            }
        }
    }
    
}
