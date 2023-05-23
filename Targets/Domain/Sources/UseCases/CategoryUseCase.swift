//
//  CategoryUseCase.swift
//  Domain
//
//  Created by 홍성준 on 2023/05/23.
//

import Foundation

public protocol CategoryUseCase {
    
    func fetchCategoryList() -> [Category]
    func insert(category: Category) throws
    func update(category: Category) throws
    func delete(category: Category) throws
    
}

public final class CategoryUseCaseImpl: CategoryUseCase {
    
    private let repository: CategoryRepository
    
    public init(repository: CategoryRepository) {
        self.repository = repository
    }
    
    public func fetchCategoryList() -> [Category] {
        return repository.fetchCategoryList()
    }
    
    public func insert(category: Category) throws {
        try repository.insert(category: category)
    }
    
    public func update(category: Category) throws {
        try repository.update(category: category)
    }
    
    public func delete(category: Category) throws {
        try repository.delete(category: category)
    }
    
}
