//
//  KeywordRepository.swift
//  Domain
//
//  Created by 홍성준 on 2023/05/21.
//

import Foundation

public protocol KeywordRepository {
    
    func fetchKeywordList(keyword: String?) -> [String]
    func store(keyword: String)
    func deleteAll()
    
}
