//
//  Loadable.swift
//  
//
//  Created by Oanea, George on 21.12.2022.
//

import SwiftUI

public enum Loadable<T> {

    case notRequested

    case isLoading(last: T?)

    case loaded(T)

    case failed(AppError)

    public var value: T? {
        switch self {
        case let .loaded(value): return value
        case let .isLoading(last): return last
        default: return nil
        }
    }

    public var error: AppError? {
        switch self {
        case let .failed(error): return error
        default: return nil
        }
    }

}
