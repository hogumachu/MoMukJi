//
//  FoodUseCase.swift
//  Domain
//
//  Created by 홍성준 on 2023/05/19.
//

import Foundation

public protocol FoodUseCase {
    
    func fetchFoodList(request: FoodRequest) -> [Food]
    func insert(food: Food) throws
    func update(food: Food) throws
    func delete(food: Food) throws
    
}

final class FoodUseCaseImpl: FoodUseCase {
    
    private let repository: FoodRepository
    
    init(repository: FoodRepository) {
        self.repository = repository
    }
    
    func fetchFoodList(request: FoodRequest) -> [Food] {
        return repository.fetchFoodList(request: request)
    }
    
    func insert(food: Food) throws {
        try repository.insert(food: food)
    }
    
    func update(food: Food) throws {
        try repository.update(food: food)
    }
    
    func delete(food: Food) throws {
        try repository.delete(food: food)
    }
    
}
