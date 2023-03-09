//
//  PluggableApplicationDelegate.swift
//  
//
//  Created by Oanea, George on 21.12.2022.
//

#if os(iOS)
import UIKit
import Foundation

open class PluggableApplicationDelegate: UIResponder {

    // MARK: - Propreties

    public var window: UIWindow?

    open var services: Array<ApplicationService> { [] }

    private lazy var internalServices: Array<ApplicationService> = {
        return self.services
    }()
}

// MARK: - Private

private extension PluggableApplicationDelegate {

    @discardableResult func apply<T, S>(_ work: (ApplicationService, @escaping (T) -> Void) -> S?,
                                        completionHandler: @escaping ([T]) -> Swift.Void) -> [S] {
        let dispatchGroup = DispatchGroup()
        var results: [T] = []
        var returns: [S] = []

        for service in internalServices {
            dispatchGroup.enter()
            let returned = work(service, { result in
                results.append(result)
                dispatchGroup.leave()
            })
            if let returned = returned {
                returns.append(returned)
            } else { // delegate doesn't impliment method
                dispatchGroup.leave()
            }
            if returned == nil {
            }
        }

        dispatchGroup.notify(queue: .main) {
            completionHandler(results)
        }

        return returns
    }

}

// MARK: - UIApplicationDelegate

extension PluggableApplicationDelegate: UIApplicationDelegate {

    open func applicationDidFinishLaunching(_ application: UIApplication) {
        internalServices.forEach { $0.applicationDidFinishLaunching?(application) }
    }

    open func application(_ application: UIApplication,
                          willFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        var result = false
        for service in internalServices {
            if service.application?(application, willFinishLaunchingWithOptions: launchOptions) ?? false {
                result = true
            }
        }
        return result
    }

    open func application(_ application: UIApplication,
                          didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        var result = false
        for service in internalServices {
            if service.application?(application, didFinishLaunchingWithOptions: launchOptions) ?? false {
                result = true
            }
        }
        return result
    }

    open func applicationDidBecomeActive(_ application: UIApplication) {
        for service in internalServices {
            service.applicationDidBecomeActive?(application)
        }
    }

    open func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        for service in internalServices {
            service.application?(application, didRegisterForRemoteNotificationsWithDeviceToken: deviceToken)
        }
    }

    open func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        for service in internalServices {
            service.application?(application, didFailToRegisterForRemoteNotificationsWithError: error)
        }
    }

    open func application(_ application: UIApplication,
                          didReceiveRemoteNotification userInfo: [AnyHashable : Any],
                          fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        for service in internalServices {
            service.application?(application, didReceiveRemoteNotification: userInfo, fetchCompletionHandler: completionHandler)
        }
    }

    open func application(_ application: UIApplication, configurationForConnecting
                          connectingSceneSession: UISceneSession,
                          options: UIScene.ConnectionOptions) -> UISceneConfiguration {

        var sceneConfiguration = UISceneConfiguration(name: connectingSceneSession.configuration.name,
                                                      sessionRole: connectingSceneSession.role)

        for service in internalServices {
            if let configuration = service.application?(application, configurationForConnecting: connectingSceneSession, options: options) {
                sceneConfiguration = configuration
            }
        }

        return sceneConfiguration
    }
}
#endif
