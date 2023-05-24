//
//  FoodObject.swift
//  Service
//
//  Created by 홍성준 on 2023/05/19.
//

import Domain
import Foundation
import RealmSwift

final class FoodObject: Object {
    
    @Persisted(primaryKey: true) private(set) var name: String
    @Persisted private(set) var count: Int
    @Persisted private(set) var category: CategoryObject?
    
    convenience init(food: Food) {
        self.init()
        self.name = food.name
        self.count = food.count
        self.category = food.category?.object()
    }
    
    var model: Food {
        return Food(name: self.name, count: self.count, category: self.category?.model)
    }
    
}

extension Food {
    
    func object() -> FoodObject {
        return FoodObject(food: self)
    }
    
}
