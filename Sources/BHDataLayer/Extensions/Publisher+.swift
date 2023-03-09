//
//  Publisher+.swift
//  
//
//  Created by Oanea, George on 21.12.2022.
//

import Combine

public extension Publisher where Output: Any, Failure == Error {

    /// Some sort of custom delay for current stream
    func fireNotEarlierThan<S: Scheduler>(
        delay: S.SchedulerTimeType.Stride = .seconds(0.400),
        on scheduler: S
    ) -> AnyPublisher<Output, Failure> {
        Publishers.CombineLatest(
            self,
            Just(()).delay(for: delay, scheduler: scheduler).setFailureType(to: Failure.self).eraseToAnyPublisher()
        )
        .map { $0.0 }
        .eraseToAnyPublisher()
    }
}
