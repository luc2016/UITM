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

    static var TMConfig: TMConfig?
    static var attachScreenShot: Bool?
    static var logPath: String?
    static var CSConfig: CSConfig?

    public class func config(
            TMConfig:           TMConfig,
            attachScreenShot:   Bool,
            CSConfig:           CSConfig = S3Config(),
            logPath:            String = "./UITM/output"
        ) {
        UITM.TMConfig = TMConfig
        UITM.attachScreenShot = attachScreenShot
        UITM.CSConfig = CSConfig
        UITM.logPath = logPath
    }
    
}
