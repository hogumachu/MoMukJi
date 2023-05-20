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

public final class FoodUseCaseImpl: FoodUseCase {
    
    private let repository: FoodRepository
    
    public init(repository: FoodRepository) {
        self.repository = repository
    }
    
    public func fetchFoodList(request: FoodRequest) -> [Food] {
        return repository.fetchFoodList(request: request)
    }
    
    public func insert(food: Food) throws {
        try repository.insert(food: food)
    }
    
    public func update(food: Food) throws {
        try repository.update(food: food)
    }
    
    public func delete(food: Food) throws {
        try repository.delete(food: food)
    }
    
}
