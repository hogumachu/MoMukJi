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
    
    @Persisted private(set) var name: String
    @Persisted private(set) var category: String
    @Persisted private(set) var count: Int
    
    convenience init(food: Food) {
        self.init()
        self.name = food.name
        self.category = food.category
        self.count = food.count
    }
    
    var model: Food {
        return Food(name: self.name, category: self.category, count: self.count)
    }
    
}

extension Food {
    
    func object() -> FoodObject {
        return FoodObject(food: self)
    }
    
}
