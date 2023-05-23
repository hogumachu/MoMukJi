//
//  CategoryRepositoryImpl.swift
//  Service
//
//  Created by 홍성준 on 2023/05/23.
//

import Domain
import Foundation
import RealmSwift

public final class CategoryRepositoryImpl: CategoryRepository {
    
    public typealias Category = Domain.Category
    
    private let realm: Realm
    
    public init(realm: Realm) {
        self.realm = realm
    }
    
    public func fetchCategoryList() -> [Category] {
        var objects = realm.objects(CategoryObject.self)
        
        return objects
            .compactMap { $0.model }
    }
    
    public func insert(category: Category) throws {
        try realm.write {
            realm.add(category.object())
        }
    }
    
    public func update(category: Category) throws {
        try delete(category: category)
        try insert(category: category)
    }
    
    public func delete(category: Category) throws {
        try realm.write {
            guard let object = realm.objects(CategoryObject.self)
                .filter({ $0.name == category.name })
                .first
            else {
                return
            }
            realm.delete(object)
        }
    }
    
}
