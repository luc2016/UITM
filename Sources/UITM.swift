//
//  File.swift
//  UITM
//
//  Created by Lu Cui (LCL) on 2018-05-11.
//

import Foundation
import AWSS3
import AWSCognito

public class UITM {
    
    static var TMService: TestManagement?
    static var TMConfig: TMConfig?
    static var attachScreenShot: Bool?
    static var CSService: CloudStorage?
    static var logPath: String?
    
    public class func config(
            TMConfig:           TMConfig,
            attachScreenShot:   Bool,
            CSConfig:           CSConfig,
            logPath:            String = "./UITM/output"
        ) {
        UITM.TMConfig = TMConfig
        UITM.attachScreenShot = attachScreenShot
        UITM.CSConfig = CSConfig
        UITM.logPath = logPath
        
        if CSConfig is S3Config {
            UITM.CSService = S3()
        }
        
        if TMConfig is ATMConfig {
            UITM.TMService = ATM()
        }
    }
    
}
