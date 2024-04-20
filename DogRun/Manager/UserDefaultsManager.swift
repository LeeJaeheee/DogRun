//
//  UserDefaultsManager.swift
//  DogRun
//
//  Created by 이재희 on 4/20/24.
//

import Foundation

// TODO: 추후 Keychain 방식으로 업데이트 필요

@propertyWrapper
struct UserDefaultsWrapper<T> {
    let key: String
    let defaultValue: T
    
    var wrappedValue: T {
        get {
            UserDefaults.standard.object(forKey: key) as? T ?? defaultValue
        }
        set {
            UserDefaults.standard.set(newValue, forKey: key)
        }
    }
}

enum UserDefaultsManager {
    enum Key: String {
        case accessToken, refreshToken, userId
    }
    
    @UserDefaultsWrapper(key: Key.accessToken.rawValue, defaultValue: "")
    static var accessToken
    
    @UserDefaultsWrapper(key: Key.refreshToken.rawValue, defaultValue: "")
    static var refreshToken
    
    @UserDefaultsWrapper(key: Key.userId.rawValue, defaultValue: "")
    static var userId
}
