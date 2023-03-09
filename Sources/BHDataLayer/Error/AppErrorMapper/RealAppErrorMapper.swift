//
//  RealAppErrorMapper.swift
//  
//
//  Created by Oanea, George on 21.12.2022.
//

public struct RealAppErrorMapper {

    // MARK: - Init

    public init() {
        // visibility
    }
}

// MARK: - AppErrorMapper

extension RealAppErrorMapper: AppErrorMapper {

    public func map(_ error: Error) -> AppError {
        guard let appError = error as? AppError else {
            return SystemError.system(reason: error.localizedDescription)
        }
        return appError
    }
}
