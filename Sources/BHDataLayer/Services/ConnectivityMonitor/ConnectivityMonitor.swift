//
//  ConnectivityMonitor.swift
//  
//
//  Created by Oanea, George on 21.12.2022.
//

import Network
import Combine

public struct ConnectivityMonitor: Publisher {

    public typealias Output = NWPath.Status

    public typealias Failure = Never

    // MARK: - Properties

    private let monitor: NWPathMonitor

    private let queue: DispatchQueue

    // MARK: - Init

    public init(monitor: NWPathMonitor = .init(), queue: DispatchQueue = .global(qos: .background)) {
        self.monitor = monitor
        self.queue = queue
    }

    // MARK: - Public

    public func receive<S>(subscriber: S) where S : Subscriber, Failure == S.Failure, Output == S.Input {
        let subscription = NetworkMonitorSubscription(subscriber: subscriber)
        subscriber.receive(subscription: subscription)
    }
}
