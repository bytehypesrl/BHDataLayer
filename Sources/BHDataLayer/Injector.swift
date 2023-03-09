//
//  Injector.swift
//  
//
//  Created by Oanea, George on 21.12.2022.
//

import Resolver
import Foundation
import BHLogging

public struct Injector {

    public static func inject() {
        BHLogging.Injector.inject()

        Resolver.register { RealRequestExecutor() as RequestExecutor }.scope(.application)

        Resolver.register { RealSessionProvider() as SessionProvider }.scope(.application)

        Resolver.register { RealAppErrorMapper() as AppErrorMapper }

        Resolver.register { RealKeychainService() as KeychainService }

        Resolver.register { RealLocalDataSource() as LocalDataSource }
    }
}
