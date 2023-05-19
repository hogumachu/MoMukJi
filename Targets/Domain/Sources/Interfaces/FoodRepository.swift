//
//  FoodRepository.swift
//  Domain
//
//  Created by 홍성준 on 2023/05/19.
//

import Foundation

public protocol FoodRepository {
    
    func fetchFoodList(request: FoodRequest) -> [Food]
    func insert(food: Food) throws
    func update(food: Food) throws
    func delete(food: Food)
    
}
