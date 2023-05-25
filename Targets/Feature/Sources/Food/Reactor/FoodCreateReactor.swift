//
//  FoodCreateReactor.swift
//  Feature
//
//  Created by 홍성준 on 2023/05/20.
//

import Foundation
import ReactorKit
import Domain

final class FoodCreateReactor: Reactor {
    
    typealias Section = FoodCreateSection
    typealias Item = FoodSearchResultTableViewCellModel
    typealias Category = Domain.Category
    
    struct Dependency {
        let coordinator: AppCoordinator
        let categoryUseCase: CategoryUseCase
        let foodUseCase: FoodUseCase
        let category: Category
    }
    
    var initialState: State
    private let dependency: Dependency
    private var foods: [Food] = []
    
    init(dependency: Dependency) {
        self.dependency = dependency
        self.initialState = State(category: dependency.category.name, keyword: nil, sections: [])
        self.foods = fetchFoodList()
    }
    
    enum Action {
        case updateKeyword(String?)
        case itemSeleted(Item)
        case addButtonTap
        case navigationLeftButtonTap
    }
    
    enum Mutation {
        case setKeyword(String)
        case setSections([Section])
    }
    
    struct State {
        var category: String
        var keyword: String?
        var sections: [Section]
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .updateKeyword(let keyword):
            return .concat([
                .just(.setKeyword(keyword ?? "")),
                .just(.setSections(makeRecentKeywordSections(keyword: keyword)))
            ])
            
        case .itemSeleted(let item):
            do {
                let food = makeCurrentFood(item: item)
                try dependency.foodUseCase.insert(food: food)
                dependency.coordinator.close(using: .dismiss, animated: true) { [weak self] in
                    self?.dependency.coordinator.refresh()
                }
                return .empty()
            } catch {
                return .empty()
            }
            
        case .addButtonTap:
            guard let food = makeCurrentFood() else {
                return .empty()
            }
            do {
                try dependency.foodUseCase.insert(food: food)
                dependency.coordinator.close(using: .dismiss, animated: true) { [weak self] in
                    self?.dependency.coordinator.refresh()
                }
                return .empty()
            } catch {
                return .empty()
            }
            
        case .navigationLeftButtonTap:
            dependency.coordinator.close(using: .pop, animated: true, completion: nil)
            return .empty()
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .setKeyword(let keyword):
            newState.keyword = keyword
            
        case .setSections(let sections):
            newState.sections = sections
        }
        return newState
    }
    
}

extension FoodCreateReactor {
    
    private func fetchFoodList() -> [Food] {
        return dependency.foodUseCase.fetchFoodList(request: FoodRequest(category: dependency.category.name))
    }
    
    private func makeRecentKeywordSections(keyword: String?) -> [Section] {
        guard let keyword, keyword.isEmpty == false else {
            return foods.isEmpty ? [] : [Section(items: foods.map { Item(food: $0.name, count: $0.count) })]
        }
        let filteredFoods = foods.filter { $0.name.contains(keyword) }
            .map { Item(food: $0.name, count: $0.count) }
        return filteredFoods.isEmpty ? [] : [Section(items: filteredFoods)]
    }
    
    private func makeCurrentFood() -> Food? {
        let name = currentState.keyword ?? ""
        let count = dependency.foodUseCase.fetchFoodList(request: FoodRequest(name: name)).first?.count ?? 0
        return Food(name: name, count: count + 1, category: dependency.category)
    }
    
    private func makeCurrentFood(item: Item) -> Food {
        let name = item.food
        return Food(name: name, count: item.count + 1, category: dependency.category)
    }
    
}
