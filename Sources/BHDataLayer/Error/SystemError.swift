//
//  SystemError.swift
//  
//
//  Created by Oanea, George on 21.12.2022.
//

import Foundation

public enum SystemError: AppError {

    // MARK: - AppError

    public var errorDescription: String {
        switch self {
        case .system(let reason):
            return reason
        }
    }

    // MARK: - Cases

    case system(reason: String)
}
