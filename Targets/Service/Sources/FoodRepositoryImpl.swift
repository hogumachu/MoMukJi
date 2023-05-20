//
//  FoodRepositoryImpl.swift
//  Service
//
//  Created by 홍성준 on 2023/05/19.
//

import Domain
import Foundation
import RealmSwift

final class FoodRepositoryImpl: FoodRepository {
    
    private let realm: Realm
    
    init(realm: Realm) {
        self.realm = realm
    }
    
    func fetchFoodList(request: FoodRequest) -> [Food] {
        var objects = realm.objects(FoodObject.self)
        
        if let predicate = request.predicate {
            objects = objects.filter(predicate)
        }
        
        return objects
            .compactMap { $0 }
            .compactMap { $0.model }
    }
    
    func insert(food: Food) throws {
        try realm.write {
            realm.add(food.object())
        }
        
    }
    
    func update(food: Food) throws {
        try delete(food: food)
        try insert(food: food)
    }
    
    func delete(food: Food) throws {
        try realm.write {
            guard let object = realm.objects(FoodObject.self)
                .filter({ $0.name == food.name })
                .first else {
                return
            }
            realm.delete(object)
        }
    }
    
}
