//
//  KeywordRepositoryImpl.swift
//  Service
//
//  Created by 홍성준 on 2023/05/21.
//

import Core
import Domain
import Foundation

public final class KeywordRepositoryImpl: KeywordRepository {
    
    public init() {}
    
    public func fetchKeywordList(keyword: String?) -> [String] {
        let keywords: [String] = UserDefaults.standard.object(key: .recentKeywordStorage) ?? []
        guard let keyword = keyword, keyword.isEmpty == false else {
            return keywords
        }
        return keywords.filter { $0.contains(keyword) }
    }
    
    public func store(keyword: String) {
        var keywords: [String] = UserDefaults.standard.object(key: .recentKeywordStorage) ?? []
        if keywords.contains(keyword) == false && keyword.isEmpty == false {
            keywords.append(keyword)
            UserDefaults.standard.setValue(keywords, key: .recentKeywordStorage)
        }
    }
    
    public func deleteAll() {
        UserDefaults.standard.removeObject(key: .recentKeywordStorage)
    }
    
}
