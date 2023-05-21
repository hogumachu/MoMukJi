//
//  KeywordUseCase.swift
//  Domain
//
//  Created by 홍성준 on 2023/05/21.
//

import Foundation

public protocol KeywordUseCase {
    
    func fetchKeywordList(keyword: String?) -> [String]
    func store(keyword: String)
    func deleteAll()
    
}

public final class KeywordUseCaseImpl: KeywordUseCase {
    
    private let repository: KeywordRepository
    
    public init(repository: KeywordRepository) {
        self.repository = repository
    }
    
    public func fetchKeywordList(keyword: String?) -> [String] {
        return repository.fetchKeywordList(keyword: keyword)
    }
    
    public func store(keyword: String) {
        repository.store(keyword: keyword)
    }
    
    public func deleteAll() {
        repository.deleteAll()
    }
    
}
