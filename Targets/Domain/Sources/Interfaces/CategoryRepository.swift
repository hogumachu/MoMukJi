//
//  CategoryRepository.swift
//  Domain
//
//  Created by 홍성준 on 2023/05/23.
//

import Foundation

public protocol CategoryRepository {
    
    func fetchCategoryList(request: CategoryRequest) -> [Category]
    func insert(category: Category) throws
    func update(category: Category) throws
    func delete(category: Category) throws
    
}
