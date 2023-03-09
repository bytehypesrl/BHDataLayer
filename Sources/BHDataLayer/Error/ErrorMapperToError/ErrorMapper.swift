//
//  ErrorMapper.swift
//  
//
//  Created by Oanea, George on 21.12.2022.
//

import Alamofire
import Foundation

public protocol ErrorMapper {

    func map(responseError: AFError, responseData: Data?) -> Error
}
