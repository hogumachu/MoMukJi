//
//  HomeReactor.swift
//  Feature
//
//  Created by 홍성준 on 2023/05/19.
//

import Core
import Domain
import RxSwift
import ReactorKit

final class HomeReactor: Reactor {
    
    typealias Section = HomeSection
    typealias Item = HomeItem
    
    var initialState = State(sections: [])
    private let dependency: Dependency
    
    struct Dependency {
        let coordinator: AppCoordinator
        let foodUseCase: FoodUseCase
    }
    
    init(dependency: Dependency) {
        self.dependency = dependency
    }
    
    enum Action {
        case refresh
        case addButtonTap
    }
    
    enum Mutation {
        case setSections([Section])
    }
    
    struct State {
        var sections: [Section]
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .refresh:
            let foods = fetchFoodList()
            let sections = makeSections(foods: foods)
            return .just(.setSections(sections))
            
        case .addButtonTap:
            dependency.coordinator.transition(to: .categoryList, using: .modal, animated: true, completion: nil)
            return .empty()
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .setSections(let sections):
            newState.sections = sections
        }
        return newState
    }
    
}

extension HomeReactor {
    
    private func fetchFoodList() -> [Food] {
        return dependency.foodUseCase
            .fetchFoodList(request: FoodRequest(category: nil))
    }
    
    private func makeSections(foods: [Food]) -> [Section] {
        let items = foods.map { food -> Item in
            return Item(name: food.name, count: food.count, category: food.category)
        }
        if items.isEmpty {
            return []
        }
        return [Section(items: items)]
    }
    
}
