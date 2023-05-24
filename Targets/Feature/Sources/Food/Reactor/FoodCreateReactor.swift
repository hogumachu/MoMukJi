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
    typealias Category = Domain.Category
    
    struct Dependency {
        let coordinator: AppCoordinator
        let categoryUseCase: CategoryUseCase
        let foodUseCase: FoodUseCase
        let category: Category
    }
    
    var initialState = State(
        keyword: nil,
        sections: [],
        foods: []
    )
    private let dependency: Dependency
    
    init(dependency: Dependency) {
        self.dependency = dependency
    }
    
    enum Action {
        case refresh
        case updateKeyword(String?)
        case itemSeleted(String)
        case addButtonTap
        case navigationLeftButtonTap
    }
    
    enum Mutation {
        case setFoods([Food])
        case setKeyword(String)
        case setSections([Section])
    }
    
    struct State {
        var keyword: String?
        var sections: [Section]
        var foods: [Food]
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .refresh:
            let foods = fetchFoodList()
            return .concat([
                .just(.setFoods(foods)),
                .just(.setKeyword("")),
                .just(.setSections(makeRecentKeywordSections(keyword: "")))
            ])
            
        case .updateKeyword(let keyword):
            return .concat([
                .just(.setKeyword(keyword ?? "")),
                .just(.setSections(makeRecentKeywordSections(keyword: keyword)))
            ])
            
        case .itemSeleted(let keyword):
            guard let food = makeCurrentFood(name: keyword) else {
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
        case .setFoods(let foods):
            newState.foods = foods
            
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
        let foods = currentState.foods.map { $0.name }
        guard let keyword else {
            return [Section(items: foods)]
        }
        
        return [Section(items: foods.filter { $0.contains(keyword) })]
    }
    
    private func makeCurrentFood(name: String? = nil) -> Food? {
        let name = name ?? (currentState.keyword ?? "")
        let count = dependency.foodUseCase.fetchFoodList(request: FoodRequest(name: name)).first?.count ?? 0
        return Food(name: name, count: count + 1, category: dependency.category)
    }
    
}
