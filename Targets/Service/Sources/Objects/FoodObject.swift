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
    @Persisted private(set) var mealtimes: List<MealtimeObject>
    @Persisted private(set) var createdAt: Date
    
    convenience init(food: Food) {
        self.init()
        self.name = food.name
        self.category = food.category?.object()
        self.mealtimes = makeMealTimes(times: food.mealtimes)
        self.createdAt = Date()
    }
    
    var model: Food {
        return Food(
            name: self.name,
            category: self.category?.model,
            mealtimes: self.mealtimes.map { $0.model }
        )
    }
    
    private func makeMealTimes(times: [Mealtime]) -> List<MealtimeObject> {
        let list = List<MealtimeObject>()
        let mealtimes = times.map { MealtimeObject(mealtime: $0) }
        list.append(objectsIn: mealtimes)
        return list
    }
    
}

extension Food {
    
    func object() -> FoodObject {
        return FoodObject(food: self)
    }
    
}

