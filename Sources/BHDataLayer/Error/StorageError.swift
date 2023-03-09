//
//  StorageError.swift
//  
//
//  Created by Oanea, George on 21.12.2022.
//

public enum StorageError: AppError, Equatable {

    // MARK: - AppError

    public var errorDescription: String {
        switch self {
        case .readError(let reason, _):
            return reason
        case .createError(let reason, _):
            return reason
        case .resourceNotFound(let reason, _):
            return reason
        }
    }

    // MARK: - Cases

    case readError(reason: String, additionalInfo: [String: String]? = nil)

    case createError(reason: String, additionalInfo: [String: String]? = nil)

    case resourceNotFound(reason: String, additionalInfo: [String: String]? = nil)
}
