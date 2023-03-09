//
//  AppErrorMapper.swift
//  
//
//  Created by Oanea, George on 21.12.2022.
//

import Foundation

public protocol AppErrorMapper {

    func map(_ error: Error) -> AppError
}
