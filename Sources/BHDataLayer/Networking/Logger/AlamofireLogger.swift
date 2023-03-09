//
//  AlamofireLogger.swift
//  
//
//  Created by Oanea, George on 15.02.2023.
//

import Resolver
import Alamofire
import BHLogging

struct AlamofireLogger: EventMonitor {

    // MARK: - Dependencies

    @Injected private var appLogger: AppLogger

    // MARK: - EventMonitor

    func requestDidResume(_ request: Request) {
        appLogger.info("[📡] \(request)")
    }

    func requestDidFinish(_ request: Request) {
        appLogger.info("[📡] \(request)")
    }
}
