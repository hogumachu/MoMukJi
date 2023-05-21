//
//  UserDefaults+.swift
//  Core
//
//  Created by 홍성준 on 2023/05/19.
//

import Foundation

public extension UserDefaults {
    
    enum Key: String {
        
        case isIntroDidShown = "isIntroDidShown" // 인트로 화면 보여짐 여부
        case recentKeywordStorage = "recentKeywordStorage" // 최근 검색어 저장
        
    }
    
    func setValue(_ value: Any?, key: UserDefaults.Key) {
        setValue(value, forKey: key.rawValue)
    }
    
    func integer(key: UserDefaults.Key) -> Int {
        integer(forKey: key.rawValue)
    }
    
    func bool(key: UserDefaults.Key) -> Bool {
        bool(forKey: key.rawValue)
    }
    
    func string(key: UserDefaults.Key) -> String? {
        string(forKey: key.rawValue)
    }
    
    func object(key: UserDefaults.Key) -> Any? {
        object(forKey: key.rawValue)
    }
    
    func object<T>(key: UserDefaults.Key) -> T? {
        object(forKey: key.rawValue) as? T
    }
    
    func removeObject(key: UserDefaults.Key) {
        removeObject(forKey: key.rawValue)
    }
    
}
