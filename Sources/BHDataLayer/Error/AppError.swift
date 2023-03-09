//
//  AppError.swift
//  
//
//  Created by Oanea, George on 21.12.2022.
//

import Foundation

public protocol AppError: LocalizedError {

    var name: String { get }

    var code: Int { get }

    var title: String { get }

    var additionalInfo: [String: String] { get }

    func asNSError(with info: [String: Any]) -> NSError
}

extension AppError {

    public var name: String {
        String(describing: self)
    }

    public var code: Int {
        0
    }

    public var title: String {
        "error_dialog_title"
    }

    public var description: String {
        errorDescription ?? localizedDescription
    }

    public var additionalInfo: [String: String] {
        [:]
    }

    public func asNSError(with info: [String: Any]) -> NSError {
        let error = self as NSError
        return NSError(domain: "\(error.domain).\(self.name)", code: self.code, userInfo: info)
    }
}
