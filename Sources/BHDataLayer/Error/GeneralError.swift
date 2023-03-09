//
//  GeneralError.swift
//  
//
//  Created by Oanea, George on 21.12.2022.
//

public enum GeneralError: AppError, Equatable {

    // MARK: - AppError

    public var errorDescription: String {
        "general_error"
    }

    // MARK: - Cases

    case emptyResponse

    case authorizationError

    case notImplemented
}
