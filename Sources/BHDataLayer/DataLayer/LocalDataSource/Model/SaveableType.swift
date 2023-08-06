//
//  SaveableType.swift
//  
//
//  Created by Oanea, George on 21.12.2022.
//

public enum SaveableType: Codable {

    case userBased

    case locationBased

    case languageBased

    case idBased(id: String)

    case none
}
