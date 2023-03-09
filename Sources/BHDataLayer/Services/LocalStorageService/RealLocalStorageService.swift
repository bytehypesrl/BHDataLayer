//
//  RealLocalStorageService.swift
//  
//
//  Created by Oanea, George on 21.12.2022.
//

import Combine
import Foundation

public class RealLocalStorageService: LocalStorageService {

    // MARK: - Properties

    private let validUntilKeySuffix = "_validUntil"

    private let userDefaults: UserDefaults

    // MARK: - Init

    public init(suitName: String) {
        userDefaults = UserDefaults(suiteName: suitName) ?? .standard
    }
}

// MARK: - LocalStorageService

public extension RealLocalStorageService {

    func save(data: Data, key: String, validity numberOfSeconds: Double = 0) {
        userDefaults.set(data, forKey: key)

        let validityInfo = getValidityInfo(for: numberOfSeconds)
        let validityInfoKey = getValidityInfoKeyName(for: key)
        userDefaults.set(validityInfo, forKey: validityInfoKey)
    }

    func get(key: String) -> Data? {
        return userDefaults.object(forKey: key) as? Data
    }

    func get<T: Decodable>(_ type: T.Type, key: String) -> T? {
        guard let data = self.get(key: key),
              let decodedData = try? JSONDecoder().decode(type, from: data)
        else {
            return nil
        }
        return decodedData
    }

    func remove(key: String) {
        userDefaults.removeObject(forKey: key)
        userDefaults.removeObject(forKey: getValidityInfoKeyName(for: key))
    }

    func save<T: Encodable>(_ value: T, key: String, validity numberOfSeconds: Double = 0) {
        guard let data = try? JSONEncoder().encode(value)
        else {
            return
        }
        save(data: data, key: key, validity: numberOfSeconds)
    }

    func isDataValid(key: String) -> Bool {
        let validityInfoKey = getValidityInfoKeyName(for: key)
        guard let validUntil = userDefaults.double(forKey: validityInfoKey) as Double? else {
            return false
        }
        if validUntil == infinityValidity {
            return true
        }
        let currentDate = Date()
        return currentDate.timeIntervalSince1970 <= validUntil
    }

    func updateDataValidity(key: String, validity numberOfSeconds: Double) {
        let validityInfo = getValidityInfo(for: numberOfSeconds)
        let validityInfoKey = getValidityInfoKeyName(for: key)
        userDefaults.set(validityInfo, forKey: validityInfoKey)
    }

    func clearStorage() {
        userDefaults.dictionaryRepresentation().keys.forEach { userDefaults.removeObject(forKey: $0) }
        userDefaults.synchronize()
    }
}

// MARK: - Private

private extension RealLocalStorageService {

    private func getValidityInfo(for numberOfSeconds: Double) -> Double {
        if numberOfSeconds == infinityValidity {
            return infinityValidity
        }
        let currentDate = Date()
        return currentDate.addingTimeInterval(TimeInterval(numberOfSeconds)).timeIntervalSince1970
    }

    private func getValidityInfoKeyName(for dataKey: String) -> String {
        dataKey + validUntilKeySuffix
    }
}
