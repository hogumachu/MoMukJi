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
    @Persisted private(set) var category: CategoryObject?
    @Persisted private(set) var time: FoodTimeObject?
    
    convenience init(food: Food) {
        self.init()
        self.name = food.name
        self.category = food.category?.object()
        self.time = food.time?.object()
    }
    
    var model: Food {
        return Food(
            name: self.name,
            category: self.category?.model,
            time: self.time?.model
        )
    }
    
}

extension Food {
    
    func object() -> FoodObject {
        return FoodObject(food: self)
    }
    
}
