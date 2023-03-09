//
//  NetworkMonitorSubscription.swift
//  
//
//  Created by Oanea, George on 21.12.2022.
//

import Network
import Combine

final class NetworkMonitorSubscription<S: Subscriber>: Subscription where S.Input == NWPath.Status {

    // MARK: - Proprieties

    private let subscriber: S?

    private let monitor: NWPathMonitor

    private let queue: DispatchQueue

    // MARK: - Init

    init(subscriber: S, monitor: NWPathMonitor = .init(), queue: DispatchQueue = .global(qos: .background)) {
        self.subscriber = subscriber
        self.monitor = monitor
        self.queue = queue
    }

    // MARK: - Public

    func request(_ demand: Subscribers.Demand) {
        monitor.pathUpdateHandler = { [weak self] path in
            guard let self = self else { return }
            _ = self.subscriber?.receive(path.status)
        }

        monitor.start(queue: queue)
    }

    func cancel() {
        monitor.cancel()
    }
}
